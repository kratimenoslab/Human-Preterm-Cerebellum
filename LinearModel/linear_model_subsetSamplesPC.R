library(spatstat.explore)
library(Seurat)
library(lme4)

meta <- read.csv("/mnt/morbo/Data/Users/kwoyshner/cerebellum/data/clinical_meta_merged_updateSampleID.csv", row.names = 1)
meta$patient <- meta$Subject_newID

meta$patient_replicate_CT <- paste0(meta$patient, meta$replicate, '_', meta$Cell_Type)

exp_data <- load('/mnt/morbo/Data/Users/kwoyshner/cerebellum/data/human_sobj_transformed_projected.rda')
spatial_matrix <- as.matrix(sobj@assays[["Spatial"]]@counts) # genes by spots
spatial_matrix <- spatial_matrix[,apply(spatial_matrix,2,max)>0] # Remove spots with no signal
spatial_matrix <- spatial_matrix[apply(spatial_matrix,1,max)>0,] # Remove genes with no signal

log_spatial_matrix <- log1p(spatial_matrix)
log_spatial_matrix <- t(log_spatial_matrix) ## CHECK THIS IS SAMPLES BY GENES NOW

meta <- meta[rownames(log_spatial_matrix),] # make sure these align

data <- merge(
    x = log_spatial_matrix,
    y = meta[,c('patient', 'Age.at.Death..weeks.', 'Gestational.Age..Weeks.', 'Cell_Type')],
    by = "row.names" # should be samples
    )

data$Preterm <- ifelse(data$Gestational.Age..Weeks. < 38, 1, 0)
data_ptsub <- data[data$patient != "NA", ]  # Remove outlier patient
data_ptsub <- data_ptsub[data_ptsub$Age.at.Death..weeks. > 45, ]
data_ptsub$patient <- as.factor(data_ptsub$patient)

#######################################################
#####################     SETUP   #####################
#######################################################

#### MODEL DESIGN :     model <- lmer(gene_expression_single ~ (1 | patient) + Gestational.Age..Weeks., data = data_sub)
variables <- c("Intercept", "Gestational.Age..Weeks.")
beta_estimates_colnames <- c(variables, paste0("t_val_", variables), paste0("F_val_", variables[-1]))
savename <- '/mnt/morbo/Data/Users/kwoyshner/cerebellum/results/linear_model/version15/coefficients'

#######################################################
#####################      PC     #####################
#######################################################
beta_estimates <- data.frame(matrix(ncol = length(beta_estimates_colnames), nrow = 0))
colnames(beta_estimates) <- beta_estimates_colnames
data_sub <- data_ptsub[data_ptsub['Cell_Type'] == 'Purkinje',] # SUBSET TO PCs

for (gene in colnames(log_spatial_matrix)) { # Loop through each gene
    gene_expression_single <- data_sub[, gene] # Extracting gene expression for a single gene, asssuming gene_expression is a matrix with rows as samples and columns as genes
    model <- lmer(gene_expression_single ~ (1 | patient) + Gestational.Age..Weeks., data = data_sub) # Define the model
    coefs <- fixef(model)     # Extract the fixed effects coefficients
    beta_estimates[gene, variables] <- coefs    # Add the coefficients to the beta_estimates data frame

    # Extract the t values
    tryCatch(
        expr = {
            # Extract the t values
            t_vals <- summary(model)[["coefficients"]][,"t value"]
            names(t_vals) <- paste0('t_val_', names(t_vals))
            beta_estimates[gene, paste0("t_val_", variables)] <- t_vals

            f_vals <- unlist(anova(model)["F value"])
            names(f_vals) <- paste0('F_val_', rownames(anova(model)["F value"]))
            beta_estimates[gene, paste0("F_val_", variables[-1])] <- f_vals
        },
        error=function(error_message) {
            message(paste0("error in ", gene))
            beta_estimates[gene, paste0("t_val_", variables)] <- c(0,0)
            beta_estimates[gene, paste0("F_val_", variables[-1])] <- c(0)
        }

    )
}
write.csv(beta_estimates, paste0(savename, '_Purkinje.csv'))


