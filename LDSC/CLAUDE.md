# Claude Code Instructions for childrens_ldsc Project

## Project Overview
This project performs LDSC (LD Score Regression) partitioned heritability enrichment analysis to test whether genomic patterns (from CoGAPS analysis) are enriched for genetic variants associated with brain disorders.

## IMPORTANT: Do Not Modify LDSC Source Code

**DO NOT edit or "fix" any files in `/home/ubuntu/childrens_ldsc/src/ldsc/`**

This includes:
- `ldsc.py` - Main LDSC script
- `make_annot.py` - Annotation file generator (has been customized for this project)
- `ldscore/*.py` - Core LDSC modules
- Any other Python files in the ldsc directory

The LDSC codebase has been carefully configured for this analysis. Any changes may break the pipeline.

## Project Structure

```
childrens_ldsc/
├── data/
│   └── CoGAPS/                    # CoGAPS input data and preparation script
├── enrichment_analysis/
│   └── project_cogaps/            # Main analysis directory (CoGAPS only)
│       ├── bedfiles/               # Pattern_*.bed files (genomic regions)
│       ├── score/                  # cogaps_score.csv (binary specificity matrix)
│       ├── out_Pattern_*/          # LD score outputs
│       ├── out_Pattern_*_2/        # Heritability enrichment results
│       ├── *.pl                    # Job generation scripts
│       └── *.txt                   # Generated job files
├── ref/
│   ├── plink_files_filtered/      # 1000G reference genotypes (hg38)
│   ├── hapmap3_snps/              # HapMap3 SNP lists
│   ├── baselineLD_v2.2_filtered/  # Baseline LD annotations (filtered)
│   ├── weights/                   # LD score regression weights
│   └── sumstats_formatted/        # GWAS summary statistics (76 traits)
└── src/
    └── ldsc/                  # LDSC software (DO NOT MODIFY)
```

## Analysis Workflow

### 1. Annotation Files
```bash
# Generate annotation files from BED files
perl ldsc_anno_jobs.pl
mamba run -n ldsc bash -c 'while read cmd; do $cmd; done < ldsc_anno_jobs.txt'
```

### 2. LD Scores
```bash
# Compute LD scores for annotations
perl ldsc_score_jobs.pl
mamba run -n ldsc bash -c 'while read cmd; do $cmd; done < ldsc_score_jobs.txt'
```

### 3. Heritability Enrichment
```bash
# Test enrichment for brain disorder GWAS
perl ldsc_h2_jobs.pl
mamba run -n ldsc bash -c 'while read cmd; do $cmd; done < ldsc_h2_jobs.txt'
```

## Environment

- **Conda environment**: `ldsc` (Python 3.9)
- **Activation**: `mamba activate ldsc` or use `mamba run -n ldsc`
- **Reference genome**: hg38/GRCh38

## Key Files Not to Touch

- `/home/ubuntu/childrens_ldsc/src/ldsc/**` - LDSC source code
- `/home/ubuntu/childrens_ldsc/ref/**` - Reference data

## When Helping With This Project

✅ **DO:**
- Help analyze results
- Explain LDSC concepts
- Debug job submission issues
- Modify Perl job generation scripts if needed
- Help with downstream analysis/visualization
- be critical 

❌ **DON'T:**
- Modify LDSC Python source code
- "Fix" or "improve" the LDSC implementation
- Change reference data files
- Alter annotation file formats without careful consideration
- be sycophantic
