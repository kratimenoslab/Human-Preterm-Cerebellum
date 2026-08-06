# Figures — reproducible code

Per-figure reproduction code for the manuscript. Each `Figure_<n>/` folder holds its analysis script
(`.Rmd` / `.R` / `.ipynb`), its rendered self-contained report (`.html`), and the exported figure
panels (`.pdf`).

## Data

The scripts read **de-identified source data provided with the journal submission** (the Supplementary
Datasets). They resolve inputs through **relative paths only** — a finder walks up to a
`Supplementary_Datasets/` folder — so to run a unit locally, place the datasets in a
`Supplementary_Datasets/` folder at the repository root. No machine- or user-specific path is embedded
in any script or rendered report.

## Relationship to the analysis pipelines

Most figure units are **self-contained** plotting scripts that read the deposited datasets. A few are
produced by, or derived from, the upstream analysis pipelines in the repository's top-level folders
([`/CoGAPS`](../CoGAPS), [`/Tricycle`](../Tricycle), [`/LDSC`](../LDSC), [`/LinearModel`](../LinearModel)):

| Figure | Produced by / derived from | Note |
|---|---|---|
| **Figure 2** | `/CoGAPS` + `/Tricycle` + `/LinearModel` | server-side pipeline; see `Figure_2/SOURCE.md` |
| **Fig. S9** | `/CoGAPS` (`n30_cogaps_fGSEA.Rmd`) | GSEA heatmap plotted from deposited GSEA results |
| **Fig. S11** | `/LDSC` | dot plot; see `Figure_S11/SOURCE.md` |
| **Fig. S17 (E–F)** | `/LinearModel` | coefficient scatter; heatmaps A–D are local; see `Figure_S17/SOURCE.md` |

All other `Figure_*` units regenerate entirely from the deposited datasets and the script in their folder.
