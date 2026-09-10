# Human Preterm Cerebellum

Code and data for the analysis of human preterm cerebellar development.

## Repository Structure

This repository contains the upstream analysis pipelines together with the per-figure and per-table
reproduction code for the manuscript:

```
Human-Preterm-Cerebellum/
├── CoGAPS/       # CoGAPS pattern analysis
├── Tricycle/     # Tricycle cell cycle analysis
├── LinearModel/  # Sample-averaged linear models
├── LDSC/         # LDSC partitioned heritability enrichment analysis
├── figures/      # Per-figure reproduction code + rendered outputs  (see figures/README.md)
└── tables/       # Per-table reproduction code + rendered outputs   (see tables/README.md)
```

### CoGAPS

Coordinated Gene Activity across Pattern Subsets (CoGAPS) analysis of cerebellar transcriptomic data. See [CoGAPS/README.md](CoGAPS/README.md).

### Tricycle

Tricycle cell cycle analysis. See [Tricycle/README.md](Tricycle/README.md).

### LDSC

LD Score Regression partitioned heritability enrichment analysis, testing whether cerebellar CoGAPS gene expression patterns are enriched for genetic variants associated with brain traits across 76 GWAS studies. See [LDSC/README.md](LDSC/README.md).

### Figures and tables

Per-figure and per-table reproduction code for the manuscript, with rendered reports and exported panels:

- **[`figures/`](figures/README.md)** — one folder per figure (`Figure_<n>/`), each with its script, rendered `.html`, and `.pdf` panels.
- **[`tables/`](tables/README.md)** — one folder per computed supplementary table.

These read the de-identified source data published with the article as Supplementary Data S1 to S5
(resolved through relative `Supplementary_Datasets/` paths; see `figures/README.md`). The mapping from each figure/table to the analysis folders above is given in
[`figures/README.md`](figures/README.md) and [`tables/README.md`](tables/README.md).

## Citation and archive

The code is archived on Zenodo; the concept DOI [10.5281/zenodo.21829813](https://doi.org/10.5281/zenodo.21829813)
always resolves to the latest released version (v1.0.0 = 10.5281/zenodo.21829814). Please cite the manuscript
(Sanidas, Simonti *et al.*, *Intrinsic Gestational Timing Governs Human Cerebellar Development After Preterm Birth*)
together with the archived release; author metadata for releases is taken from `.zenodo.json` / `CITATION.cff`.
