
library(here)
# read data
dat <- read.table(here("enrichment_analysis/project_cogaps/ldsc_results_cogaps.txt"),as.is=T,header=T,sep="\t")

# # Filter for brain disorder traits
# traits <- c(
#   "Alzheimer's Disease",
#   "Autism Spectrum Disorder",
#   "Bipolar Disorder",
#   "Multiple Sclerosis",
#   "Schizophrenia"
# )
# idx <- is.element(dat$trait,traits)
# dat <- dat[idx,]
# 
# # Optional: shorten trait names for plotting (if needed)
# dat$trait[dat$trait=="Autism Spectrum Disorder"] <- "Autism"
# dat$trait[dat$trait=="Alzheimer's Disease"] <- "Alzheimer's"

# FDR
dat$p_zcore <- pnorm(abs(dat$Coefficient_z.score),lower.tail=F)*2
dat$FDR <- p.adjust(dat$p_zcore,method="fdr")


write.csv(dat,here("enrichment_analysis/project_cogaps/ldsc_results_cogaps.csv"))






