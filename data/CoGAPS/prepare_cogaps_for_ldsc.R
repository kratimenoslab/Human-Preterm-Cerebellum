#!/usr/bin/env Rscript
# Convert CoGAPS gene weights to LDSC-compatible specificity scores
# This replaces Steps 0-1 of the LDSC pipeline for CoGAPS data
library(here)
library(tidyverse)

# ==============================================================================
# CONFIGURATION - Update these paths
# ==============================================================================

# Input: Your CoGAPS gene weights file
# Expected format: First column = gene names, remaining columns = Pattern_1, Pattern_2, etc.
cogaps_file <- here("data/CoGAPS/human_CB_cogaps_n30_nIterations15k_allGenes_geneWeights.csv") 

# Output: Specificity score matrix for LDSC
output_file <- here("enrichment_analysis/project_cogaps/score/cogaps_score.csv")

# Specificity threshold (default: top 10% of genes per pattern)
top_percentile <- 0.90  # 90th percentile = top 10%

# ==============================================================================
# STEP 1: Load CoGAPS gene weights
# ==============================================================================

cat("Loading CoGAPS gene weights from:", cogaps_file, "\n")

# Read the gene weights
# Adjust read function based on your file format (.csv, .tsv, .rds, etc.)
geneweights <- read_csv(cogaps_file)  # or read_tsv() or read.table()

# Check the data structure
cat("Data dimensions:", nrow(geneweights), "genes x", ncol(geneweights)-1, "patterns\n")
cat("Column names:", paste(colnames(geneweights), collapse=", "), "\n")

# ==============================================================================
# STEP 2: Convert to matrix format with gene names as rownames
# ==============================================================================

# Extract gene names (assuming first column contains gene names)
gene_names <- geneweights[[1]]

# Extract pattern weights (all columns except the first)
pattern_cols <- geneweights %>%
  dplyr::select(-1)  # All columns except first (gene names)

# Convert to matrix with gene names as rownames
weights_matrix <- as.matrix(pattern_cols)
rownames(weights_matrix) <- gene_names

cat("Pattern weight matrix created:", nrow(weights_matrix), "genes x",
    ncol(weights_matrix), "patterns\n")

# Verify gene names look like human genes (should be uppercase)
sample_genes <- head(gene_names, 5)
cat("Sample gene names:", paste(sample_genes, collapse=", "), "\n")
if (any(grepl("^[a-z]", sample_genes))) {
  warning("Gene names appear to start with lowercase letters (mouse genes?).\n",
          "Expected human gene symbols (e.g., APOE, BDNF, not Apoe, Bdnf).\n",
          "Did you run convert_mouse_to_human_babelgene.R first?")
}

# ==============================================================================
# STEP 3: Compute specificity scores (top percentile approach)
# ==============================================================================

cat("Computing specificity scores using top", (1-top_percentile)*100,
    "% threshold...\n")

# Function to identify top genes per pattern
is_top_percentile <- function(column, percentile = top_percentile) {
  threshold <- quantile(column, percentile, na.rm = TRUE)
  as.numeric(column >= threshold)
}

# Apply to each pattern
specificity_scores <- apply(weights_matrix, 2, is_top_percentile)
rownames(specificity_scores) <- gene_names

# Convert to data frame for export
specificity_df <- as.data.frame(specificity_scores)
specificity_df$gene_name <- gene_names

# Reorder columns (gene_name first)
specificity_df <- specificity_df %>%
  dplyr::select(gene_name, everything())

# ==============================================================================
# STEP 4: Quality checks and summary
# ==============================================================================

cat("\n=== Specificity Score Summary ===\n")
cat("Total genes:", nrow(specificity_df), "\n")
cat("Total patterns:", ncol(specificity_df)-1, "\n")

# Count specific genes per pattern
genes_per_pattern <- colSums(specificity_df[,-1])
cat("\nGenes per pattern (should be ~10% of total):\n")
print(genes_per_pattern)

# Check for genes specific to multiple patterns
genes_with_specificity <- rowSums(specificity_df[,-1])
cat("\nDistribution of pattern specificity per gene:\n")
print(table(genes_with_specificity))

# Identify patterns with very few specific genes (potential issues)
low_gene_patterns <- names(genes_per_pattern[genes_per_pattern < 100])
if (length(low_gene_patterns) > 0) {
  cat("\nWARNING: The following patterns have < 100 specific genes:\n")
  print(genes_per_pattern[low_gene_patterns])
  cat("Consider lowering the percentile threshold for these patterns.\n")
}

# ==============================================================================
# STEP 5: Save output
# ==============================================================================

cat("\nSaving specificity scores to:", output_file, "\n")
write.csv(specificity_df, output_file, row.names = FALSE)

cat("\n=== DONE ===\n")
cat("Specificity scores written to:", output_file, "\n\n")
cat("Next steps:\n")
cat("1. Verify output looks correct:\n")
cat("   head", output_file, "\n")
cat("2. Generate BED files:\n")
cat("   cd project_all/bedfiles\n")
cat("   Update bed.R line 4: cell <- read.csv('../score/cogaps_score.csv')\n")
cat("   Rscript bed.R\n")
cat("3. Run LDSC pipeline:\n")
cat("   cd ../\n")
cat("   perl ldsc_anno_jobs.pl\n")
cat("   perl ldsc_score_jobs.pl\n")
cat("   perl ldsc_h2_jobs.pl\n")
cat("4. Collect results:\n")
cat("   perl ldsc_results.pl\n")
cat("   Rscript ldsc_results2.R\n")
