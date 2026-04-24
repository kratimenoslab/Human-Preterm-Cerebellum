library(spatstat.explore)
library(Seurat)
library(lme4)
library(pheatmap)
library(CoGAPS)
library(dplyr)

#######################################################
###############  PREP EXPRESSION DATA  ################
#######################################################

load("/mnt/morbo/Data/Users/kwoyshner/cerebellum/data/human_sobj_transformed_projected.rda")
sobj_sub = sobj
print(dim(sobj_sub))

spatial_matrix <- as.matrix(sobj_sub@assays[["Spatial"]]@counts)
log_spatial_matrix <- log1p(spatial_matrix)
log_spatial_matrix <- t(log_spatial_matrix)

meta <- read.csv("/mnt/morbo/Data/Users/kwoyshner/cerebellum/data/clinical_meta_merged_updateSampleID.csv", row.names = 1)
meta$patient <- meta$Subject_newID

meta <- meta[rownames(log_spatial_matrix),] # make sure these align

data <- merge(
    x = log_spatial_matrix,
    y = meta[,c('patient', 'Gestational.Age..Weeks.', 'Age.at.Death..weeks.', 'AGEDAYSTOTAL', 'Cell_Type')],
    by = "row.names" # should be samples
    )

rownames(data) <- data$Row.names
data$Preterm <- ifelse(data$Gestational.Age..Weeks. < 38, 1, 0) # define preterm as < 38 weeks
data_ptsub <- data[data$patient != "NA", ]  # Remove outlier patient
data_ptsub$patient <- as.factor(data_ptsub$patient) # make patient a factor
data_ptsub <- data_ptsub[data_ptsub$Age.at.Death..weeks. > 45, ] # subset to PMA > 45 (drop low outliers)

n_genes <- 20 # ngenes to plot
lmer_outputs <- '/mnt/morbo/Data/Users/kwoyshner/cerebellum/results/linear_model/version15/coefficients_'

#sort_col <- 'Gestational.Age..Weeks.'
#annot_name <- 'Gestational Age (weeks)'

savename <- "/mnt/morbo/Data/Users/kwoyshner/cerebellum/results/linear_model/version15/plot_heatmaps/heatmap_zscore_ptAverage_GAsort_" #coef vs tval

######
# Notes model is:     model <- lmer(gene_expression_single ~ (1 | patient) + Gestational.Age..Weeks., data = data_sub)


#######################################################
###############        PCs         ####################
#######################################################

lm_genes <- read.csv(paste0(lmer_outputs, 'Purkinje.csv'), row.names = 1) # input PC file
lm_genes <- lm_genes[complete.cases(lm_genes), ] # remove NAs
data_sub <- data_ptsub[data_ptsub['Cell_Type'] == 'Purkinje',]  # subset to PCs

df_summary <- data_sub %>%
  group_by(patient) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE),  # Average numeric columns
            across(where(is.character), first))             # Take the first value of non-numeric columns

data_sub_grouped <- as.data.frame(df_summary) # group by patient
rownames(data_sub_grouped) <- data_sub_grouped$patient

######################################################
##################    Gestational.Age..Weeks.   #####################
coef_col <- 'Gestational.Age..Weeks.'
tval_col <- paste0('t_val_',coef_col)

####################### COEFS ########################
sorted_coef <- lm_genes[rev(order(lm_genes[[coef_col]])),]

# check the 20 top and bottom genes are pos and neg respectively
if ((min(head(sorted_coef, n_genes)[[coef_col]]) > 0) & (max(tail(sorted_coef, n_genes)[[coef_col]]) < 0)) {
    print("All positive and all negative genes selected")
} else {
   print("DONT USE THIS")
}

coef_sigs <- rbind(head(sorted_coef, n_genes),tail(sorted_coef, n_genes))
sample_info <- data_sub_grouped[order(data_sub_grouped$Gestational.Age..Weeks.,data_sub_grouped$patient),]

gene_info <- data.frame(
    Direction = c(rep("Positive",n_genes), rep("Negative",n_genes)),
    Amplitude = abs(coef_sigs[[coef_col]]),
    row.names = rownames(coef_sigs) 
    )

annotation_col <- data.frame(
    Gestational_Age = data_sub_grouped$Gestational.Age..Weeks.,
    PT = ifelse(data_sub_grouped$Gestational.Age..Weeks. < 38, 'Preterm', 'Term'),
    patient = factor(data_sub_grouped$patient),
    row.names = rownames(data_sub_grouped)
)

data_zScore <- scale(sample_info[,rownames(gene_info)], center = TRUE, scale = TRUE) # checked colMeans ~ 0 and col std aka apply(PC,2,sd) = 1

# Calculate the 5th and 95th percentiles
vmin <- quantile(t(data_zScore), 0.05)
vmax <- quantile(t(data_zScore), 0.95)
my_colors <- colorRampPalette(c("blue", "white", "red"))(100)

max_abs_val <- max(abs(c(vmin, vmax)))
breaks <- seq(-max_abs_val, max_abs_val, length.out = 101)

pdf(paste0(savename, coef_col,  "_PC.pdf"))

p <- pheatmap(t(data_zScore),
    annotation_col = annotation_col[rownames(data_zScore),,drop=FALSE],
    annotation_row = gene_info,
    cluster_rows=FALSE,
    cluster_cols=FALSE,
    show_colnames = FALSE,
    gaps_row = c(sum(gene_info$Direction == 'Positive')),
    gaps_col = c(sum(annotation_col$Gestational_Age < 38)),
    color = my_colors,      
    breaks = breaks
    )
p

dev.off()


####################### T VALS ########################
sorted_tval <- lm_genes[rev(order(lm_genes[[tval_col]])),]

# check the 20 top and bottom genes are pos and neg respectively
if ((min(head(sorted_tval, n_genes)[[tval_col]]) > 0) & (max(tail(sorted_tval, n_genes)[[tval_col]]) < 0)) {
    print("All positive and all negative genes selected")
} else {
   print("DONT USE THIS")
}

tval_sigs <- rbind(head(sorted_tval, n_genes),tail(sorted_tval, n_genes))

sample_info <- data_sub_grouped[order(data_sub_grouped$Gestational.Age..Weeks., data_sub_grouped$patient),]

gene_info <- data.frame(
    Direction = c(rep("Positive",n_genes), rep("Negative",n_genes)),
    Amplitude = abs(tval_sigs[[tval_col]]),
    row.names = rownames(tval_sigs) 
    )

annotation_col <- data.frame(
    Gestational_Age = data_sub_grouped$Gestational.Age..Weeks.,
    PT = ifelse(data_sub_grouped$Gestational.Age..Weeks. < 38, 'Preterm', 'Term'),
    patient = factor(data_sub_grouped$patient),
    row.names = rownames(data_sub_grouped)
)

data_zScore <- scale(sample_info[,rownames(gene_info)], center = TRUE, scale = TRUE) # checked colMeans ~ 0 and col std aka apply(PC,2,sd) = 1

# Calculate the 5th and 95th percentiles
vmin <- quantile(t(data_zScore), 0.05)
vmax <- quantile(t(data_zScore), 0.95)
breaks <- seq(vmin, vmax, length.out = 101)
my_colors <- colorRampPalette(c("blue", "white", "red"))(100)
max_abs_val <- max(abs(c(vmin, vmax)))
breaks <- seq(-max_abs_val, max_abs_val, length.out = 101)

pdf(paste0(savename, tval_col,  "_PC.pdf"))

p <- pheatmap(t(data_zScore),
    annotation_col = annotation_col[rownames(data_zScore),,drop=FALSE],
    annotation_row = gene_info,
    cluster_rows=FALSE,
    cluster_cols=FALSE,
    show_colnames = FALSE,
    gaps_row = c(sum(gene_info$Direction == 'Positive')),
    gaps_col = c(sum(annotation_col$Gestational_Age < 38)),
    color = my_colors,     
    breaks = breaks
    )
p
dev.off()



#######################################################
###############        GCs         ####################
#######################################################

lm_genes <- read.csv(paste0(lmer_outputs, 'Granular.csv'), row.names = 1) # input PC file
lm_genes <- lm_genes[complete.cases(lm_genes), ] # remove NAs
data_sub <- data_ptsub[data_ptsub['Cell_Type'] == 'Granular',]  # subset to PCs

df_summary <- data_sub %>%
  group_by(patient) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE),  # Average numeric columns
            across(where(is.character), first))             # Take the first value of non-numeric columns

data_sub_grouped <- as.data.frame(df_summary) # group by patient
rownames(data_sub_grouped) <- data_sub_grouped$patient

######################################################
################## Gestational.Age..Weeks. ######################

coef_col <- 'Gestational.Age..Weeks.'
tval_col <- paste0('t_val_',coef_col)

####################### COEFS ########################
sorted_coef <- lm_genes[rev(order(lm_genes[[coef_col]])),]

# check all pos and all neg
if ((min(head(sorted_coef, n_genes)[[coef_col]]) > 0) & (max(tail(sorted_coef, n_genes)[[coef_col]]) < 0)) {
    print("All positive and all negative genes selected")
} else {
   print("DONT USE THIS")
}

coef_sigs <- rbind(head(sorted_coef, n_genes),tail(sorted_coef, n_genes))
sample_info <- data_sub_grouped[order(data_sub_grouped$Gestational.Age..Weeks.,data_sub_grouped$patient),]

gene_info <- data.frame(
    Direction = c(rep("Positive",n_genes), rep("Negative",n_genes)),
    Amplitude = abs(coef_sigs[[coef_col]]),
    row.names = rownames(coef_sigs) 
    )

annotation_col <- data.frame(
    Gestational_Age = data_sub_grouped$Gestational.Age..Weeks.,
    PT = ifelse(data_sub_grouped$Gestational.Age..Weeks. < 38, 'Preterm', 'Term'),
    patient = factor(data_sub_grouped$patient),
    row.names = rownames(data_sub_grouped)
)

data_zScore <- scale(sample_info[,rownames(gene_info)], center = TRUE, scale = TRUE) # checked colMeans ~ 0 and col std aka apply(PC,2,sd) = 1

# Calculate the 5th and 95th percentiles
vmin <- quantile(t(data_zScore), 0.05)
vmax <- quantile(t(data_zScore), 0.95)
my_colors <- colorRampPalette(c("blue", "white", "red"))(100)

max_abs_val <- max(abs(c(vmin, vmax)))
breaks <- seq(-max_abs_val, max_abs_val, length.out = 101)

pdf(paste0(savename, coef_col,  "_GC.pdf"))

p <- pheatmap(t(data_zScore),
    annotation_col = annotation_col[rownames(data_zScore),,drop=FALSE],
    annotation_row = gene_info,
    cluster_rows=FALSE,
    cluster_cols=FALSE,
    show_colnames = FALSE,
    gaps_row = c(sum(gene_info$Direction == 'Positive')),
    gaps_col = c(sum(annotation_col$Gestational_Age < 38)),
    color = my_colors,   
    breaks = breaks
    )
p

dev.off()


####################### T VALS ########################
sorted_tval <- lm_genes[rev(order(lm_genes[[tval_col]])),]

# check all pos and all neg
if ((min(head(sorted_tval, n_genes)[[tval_col]]) > 0) & (max(tail(sorted_tval, n_genes)[[tval_col]]) < 0)) {
    print("All positive and all negative genes selected")
} else {
   print("DONT USE THIS")
}

tval_sigs <- rbind(head(sorted_tval, n_genes),tail(sorted_tval, n_genes))

sample_info <- data_sub_grouped[order(data_sub_grouped$Gestational.Age..Weeks., data_sub_grouped$patient),]

gene_info <- data.frame(
    Direction = c(rep("Positive",n_genes), rep("Negative",n_genes)),
    Amplitude = abs(tval_sigs[[tval_col]]),
    row.names = rownames(tval_sigs) 
    )

annotation_col <- data.frame(
    Gestational_Age = data_sub_grouped$Gestational.Age..Weeks.,
    PT = ifelse(data_sub_grouped$Gestational.Age..Weeks. < 38, 'Preterm', 'Term'),
    patient = factor(data_sub_grouped$patient),
    row.names = rownames(data_sub_grouped)
)

data_zScore <- scale(sample_info[,rownames(gene_info)], center = TRUE, scale = TRUE) # checked colMeans ~ 0 and col std aka apply(PC,2,sd) = 1

# Calculate the 5th and 95th percentiles
vmin <- quantile(t(data_zScore), 0.05)
vmax <- quantile(t(data_zScore), 0.95)
breaks <- seq(vmin, vmax, length.out = 101)
my_colors <- colorRampPalette(c("blue", "white", "red"))(100)
max_abs_val <- max(abs(c(vmin, vmax)))
breaks <- seq(-max_abs_val, max_abs_val, length.out = 101)

pdf(paste0(savename, tval_col,  "_GC.pdf"))

p <- pheatmap(t(data_zScore),
    annotation_col = annotation_col[rownames(data_zScore),,drop=FALSE],
    annotation_row = gene_info,
    cluster_rows=FALSE,
    cluster_cols=FALSE,
    show_colnames = FALSE,
    gaps_row = c(sum(gene_info$Direction == 'Positive')),
    gaps_col = c(sum(annotation_col$Gestational_Age < 38)),
    color = my_colors,  
    breaks = breaks
    )
p
dev.off()


