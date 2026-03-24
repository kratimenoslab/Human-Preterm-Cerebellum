# LDSC Partitioned Heritability Enrichment of Cerebellar CoGAPS Patterns

## Overview

This repository contains the code and data for testing whether cerebellar gene expression patterns
identified by CoGAPS are enriched for genetic variants associated with brain traits, using
**LD Score Regression (LDSC) partitioned heritability analysis**.

- **28 CoGAPS patterns** from bulk cerebellar transcriptomic data
- **76 GWAS traits**: psychiatric disorders, neurological disorders, cognitive traits, brain imaging
  phenotypes (UK Biobank), and non-brain control traits
- **2,128 tests** (28 patterns × 76 traits), FDR-corrected at 0.05

Gene expression patterns were converted to binary genomic annotations (gene loci ±100 kb, hg38),
conditioned on the baseline LD model v2.2 (97 functional annotations) using 1000 Genomes Phase 3
EUR reference genotypes.

---

## Repository Structure

```
childrens_ldsc/
├── data/
│   └── CoGAPS/
│       ├── human_CB_cogaps_n30_nIterations15k_allGenes_geneWeights.csv   # CoGAPS input (9.7 MB)
│       └── prepare_cogaps_for_ldsc.R    # Converts weights → binary specificity scores
├── enrichment_analysis/
│   └── project_cogaps/
│       ├── bedfiles/
│       │   ├── bed.R                   # Generates BED files from score matrix
│       │   └── Pattern_*.bed           # Genomic annotations (28 files)
│       ├── score/
│       │   └── cogaps_score.csv        # Binary specificity matrix (top 10% per pattern)
│       ├── ldsc_anno_jobs.pl           # Step 1: Generate annotation job commands
│       ├── ldsc_score_jobs.pl          # Step 2: Generate LD score job commands
│       ├── ldsc_h2_jobs.pl             # Step 3: Generate heritability job commands
│       ├── ldsc_results.pl             # Collect results into flat table
│       ├── ldsc_results2.R             # Compute FDR, format results table
│       ├── plot_ldsc_enrichment.R      # Generate publication heatmap
│       ├── ldsc_results_cogaps.csv     # Full results table
│       ├── ldsc_enrichment_heatmap_full_cogaps.pdf   # Publication figure
│       └── ldsc_enrichment_heatmap_full_cogaps.png   # Publication figure
├── ref/
│   ├── gene_meta_hg38.txt              # Ensembl gene coordinates (hg38)
│   ├── hapmap3_snps/                   # HapMap3 SNP lists (see download below)
│   ├── Childrens GWAS studies - Sheet1.csv  # GWAS trait metadata
│   └── [large reference data — see Data Availability below]
└── src/
    └── ldsc/                           # LDSC software (DO NOT MODIFY)
```

---

## Prerequisites

### Software

- **Python 3.9** (conda environment `ldsc`)
- **R >= 4.0** with packages: `tidyverse`, `here`
- **Perl** (for job generation scripts)

### Install conda environment

```bash
mamba create -n ldsc python=3.9
mamba activate ldsc
pip install numpy scipy pandas bitarray
```

### Install R packages

```R
install.packages(c("tidyverse", "here"))
```

---

## Data Availability

The following large files are not tracked in git. Download them before running the pipeline.

### 1000 Genomes Phase 3 EUR (hg38) PLINK files

**Location:** `ref/plink_files_filtered/`

Files: `1000G.EUR.hg38.{1..22}.{bed,bim,fam}`

Available from the LDSC Google Drive:
https://drive.google.com/drive/folders/1SYQVO4dHQY8XA7d65e_gLajeFYbbaJEI

### Baseline LD model v2.2

**Location:** `ref/baselineLD_v2.2_filtered/`

Files: `baselineLD.{1..22}.annot.gz`, `.l2.ldscore.gz`, `.l2.M`, `.l2.M_5_50`

Available from the LDSC Google Drive (same link as above).

### LD score regression weights

**Location:** `ref/weights/`

Files: `weights.hm3_noMHC.{1..22}.l2.ldscore.gz`

Available from the LDSC Google Drive (same link as above).

### HapMap3 SNPs

**Location:** `ref/hapmap3_snps/`

A download script is included:

```bash
bash ref/download_hapmap3_snps.sh
```

### GWAS summary statistics

**Location:** `ref/sumstats_formatted/`

76 traits (munged `.sumstats.gz` files). Download scripts and sources:

```bash
bash ref/munge_gwas.sh
bash ref/download_imaging_phenotype_sum_stats.sh
```

Trait metadata: `ref/Childrens GWAS studies - Sheet1.csv`

---

## Analysis Workflow

All Perl scripts generate job files that are then executed. Run from the project directory:

```bash
cd enrichment_analysis/project_cogaps/
```

### Step 0: Prepare input data

Convert CoGAPS gene weights to binary specificity scores (top 10% per pattern):

```bash
Rscript data/CoGAPS/prepare_cogaps_for_ldsc.R
```

Output: `enrichment_analysis/project_cogaps/score/cogaps_score.csv`

Generate BED files (gene loci ±100 kb for each pattern):

```bash
Rscript enrichment_analysis/project_cogaps/bedfiles/bed.R
```

Output: `enrichment_analysis/project_cogaps/bedfiles/Pattern_*.bed` (28 files)

### Step 1: Compute annotation files

```bash
perl ldsc_anno_jobs.pl
mamba run -n ldsc bash -c 'while read cmd; do $cmd; done < ldsc_anno_jobs.txt'
```

Output: `out_Pattern_*/chr.{1..22}.annot.gz`

### Step 2: Compute LD scores

```bash
perl ldsc_score_jobs.pl
mamba run -n ldsc bash -c 'while read cmd; do $cmd; done < ldsc_score_jobs.txt'
```

Output: `out_Pattern_*/chr.{1..22}.l2.ldscore.gz`

### Step 3: Heritability enrichment regression

```bash
perl ldsc_h2_jobs.pl
mamba run -n ldsc bash -c 'while read cmd; do $cmd; done < ldsc_h2_jobs.txt'
```

Output: `out_Pattern_*_2/*.results` (one file per pattern × trait combination)

### Step 4: Collect and analyze results

```bash
perl ldsc_results.pl          # Collects results into ldsc_results_cogaps.txt
Rscript ldsc_results2.R       # Computes FDR, writes ldsc_results_cogaps.csv
```

### Step 5: Generate figures

```bash
Rscript plot_ldsc_enrichment.R
```

Output: `ldsc_enrichment_heatmap_full_cogaps.pdf/png`

---

## Results

The full results table is in `enrichment_analysis/project_cogaps/ldsc_results_cogaps.csv` with columns:

| Column | Description |
|--------|-------------|
| Pattern | CoGAPS pattern ID |
| Trait | GWAS phenotype |
| Prop_SNPs | Proportion of genome-wide SNPs in pattern annotation |
| Prop_h2 | Proportion of SNP heritability explained by pattern |
| Enrichment | Prop_h2 / Prop_SNPs |
| Enrichment_SE | Standard error of enrichment |
| Enrichment_p | One-sided p-value |
| FDR | Benjamini-Hochberg FDR across 2,128 tests |

Publication figures: `ldsc_enrichment_heatmap_full_cogaps.pdf/.png`

---

## Citation

If you use this code, please cite:

- Bulik-Sullivan et al. (2015) *Nat Genet* 47:291–295
- Finucane et al. (2015) *Nat Genet* 47:1228–1235
- Stein-O'Brien et al. (2018) *Trends Genet* 34:790–805
