library(CoGAPS)
library(Matrix)
library(gdata)
library(Seurat)
library(ggplot2)

## Run for all spots
load("human_sobj_transformed_projected.rda")

spatial_matrix <- as.matrix(sobj@assays[["Spatial"]]@counts) # genes by spots
spatial_assay <- sobj@assays[['Spatial']] # genes x cells

# Remove spots with no signal
spatial_matrix <- spatial_matrix[,apply(spatial_matrix,2,max)>0]
# Remove genes with no signal
spatial_matrix <- spatial_matrix[apply(spatial_matrix,1,max)>0,]

log_spatial_matrix <- log1p(spatial_matrix)

## Set params
nPatterns = 30
nIterations = 15000

params <- new("CogapsParams")
geneNames <- rownames(log_spatial_matrix)
spotNames <- colnames(log_spatial_matrix)
params <- CogapsParams(
  sparseOptimization=FALSE,
  nPatterns=nPatterns,
  seed=123,
  geneNames=geneNames,
  sampleNames=spotNames,
  nIterations=nIterations,
  distributed='single-cell'
)

cogaps.exprs<-log_spatial_matrix
params <- setDistributedParams(params, nSets=18) #4k cells per set
savename <- paste0('human_CB_cogaps_n',nPatterns,'_nIterations',nIterations/1000,'k_allGenes')
outputDir <- '/mnt/morbo/Data/Users/kwoyshner/cerebellum/results/human_allGenes/'
print(paste0(outputDir,savename,".RDS"))
cat("Test",file=paste0(outputDir,savename,"test.txt"),append=TRUE) # Save test file to output location before running whole model


NMF<-CoGAPS(as.matrix(cogaps.exprs),params = params, distributed="single-cell", outputFrequency=500)
saveRDS(NMF,file=paste0(outputDir,savename,".RDS"))

# P matrix = samples x Patterns
sampleWeights<-t(NMF@sampleFactors) # patterns x samples
colnames(sampleWeights)<-colnames(log_spatial_matrix)
write.csv(sampleWeights, paste0(outputDir, savename, "_patterns.csv"))

# A matrix = genes x Patterns
geneWeights<-NMF@featureLoadings
rownames(geneWeights)<-rownames(log_spatial_matrix)
write.csv(geneWeights, paste0(outputDir, savename, "_geneWeights.csv"))
