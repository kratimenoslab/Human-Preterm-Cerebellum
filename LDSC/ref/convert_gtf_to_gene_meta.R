#!/usr/bin/env Rscript
# Convert GTF file to gene_meta_hg38.txt format for LDSC pipeline
# Required format: Gene.name, Chromosome, Start, End (tab-separated)

library(tidyverse)

# ==============================================================================
# CONFIGURATION - Edit these paths
# ==============================================================================

# Input GTF file path
# Download from: https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.annotation.gtf.gz
gtf_file <- "gencode.v46.annotation.gtf.gz"  # Can read .gz directly

# Output file path
output_file <- "gene_meta_hg38.txt"

# ==============================================================================
# PROCESSING
# ==============================================================================

cat("Reading GTF file:", gtf_file, "\n")

# Read GTF file (skip header lines starting with #)
gtf <- read_tsv(
  gtf_file,
  col_names = c("seqname", "source", "feature", "start", "end",
                "score", "strand", "frame", "attribute"),
  col_types = cols(.default = "c"),
  comment = "#",
  progress = TRUE
)

cat("Total entries:", nrow(gtf), "\n")

# Filter for gene-level entries only
genes <- gtf %>%
  filter(feature == "gene")

cat("Gene entries:", nrow(genes), "\n")

# Extract gene name from the attributes column
# Attributes format: gene_id "ENSG..."; gene_name "GENE"; ...
extract_gene_name <- function(attr) {
  # Look for gene_name "XXXX"
  gene_name <- str_extract(attr, 'gene_name "([^"]+)"')
  gene_name <- str_replace(gene_name, 'gene_name "', '')
  gene_name <- str_replace(gene_name, '"', '')
  return(gene_name)
}

cat("Extracting gene names...\n")
genes$gene_name <- sapply(genes$attribute, extract_gene_name)

# Create final output dataframe
gene_meta <- genes %>%
  select(gene_name, seqname, start, end) %>%
  mutate(
    # Remove "chr" prefix if present (LDSC expects just chromosome number)
    seqname = str_replace(seqname, "^chr", ""),
    # Convert start and end to numeric
    start = as.numeric(start),
    end = as.numeric(end)
  ) %>%
  # Filter out genes on non-standard chromosomes (keep 1-22, X, Y, MT)
  filter(seqname %in% c(as.character(1:22), "X", "Y", "MT")) %>%
  # Remove any rows with missing gene names
  filter(!is.na(gene_name), gene_name != "") %>%
  # Remove duplicate gene names (keep first occurrence)
  distinct(gene_name, .keep_all = TRUE) %>%
  # Rename columns to match expected format
  rename(
    Gene.name = gene_name,
    Chromosome = seqname,
    Start = start,
    End = end
  )

cat("\n=== Summary ===\n")
cat("Total genes after filtering:", nrow(gene_meta), "\n")
cat("Chromosomes included:", paste(unique(gene_meta$Chromosome), collapse = ", "), "\n")
cat("\nFirst few entries:\n")
print(head(gene_meta))

# Write output file (tab-separated)
cat("\nWriting to:", output_file, "\n")
write.table(
  gene_meta,
  file = output_file,
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  col.names = TRUE
)

cat("\n✓ Done! Gene annotation file created successfully.\n")
cat("Use this file in project_all/bedfiles/bed.R\n")
