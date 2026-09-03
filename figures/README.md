# Figures — reproducible code

Per-figure reproduction code for the manuscript. Each `Figure_<n>/` folder holds its analysis script
(`.Rmd` / `.R` / `.ipynb`), its rendered self-contained report (`.html`), and the exported figure
panels (`.pdf`).

## Data

The scripts read the **de-identified source data published with the article as Supplementary Data S1 to S5**
(`Data_S1_InVivo_Cohort.xlsx`, `Data_S2_Postmortem_Histology.xlsx`, `Data_S3_SpatialTx_Tables.xlsx`,
`Data_S4_SpatialTx_SpotMatrices.zip` → two CSV files, `Data_S5_InSitu_Validation.xlsx`). They resolve inputs
through **relative paths only** — a finder walks up to a `Supplementary_Datasets/` folder — so to run a unit
locally, download the Data S1–S5 files (unzip Data S4) into a `Supplementary_Datasets/` folder at the
repository root. No machine- or user-specific path is embedded
in any script or rendered report.

## Relationship to the analysis pipelines

Most figure units are **self-contained** plotting scripts that read the deposited datasets. A few are
produced by, or derived from, the upstream analysis pipelines in the repository's top-level folders
([`/CoGAPS`](../CoGAPS), [`/Tricycle`](../Tricycle), [`/LDSC`](../LDSC), [`/LinearModel`](../LinearModel)):

| Figure | Produced by / derived from | Note |
|---|---|---|
| **Figure 2** | `/CoGAPS` + `/Tricycle` + `/LinearModel` | server-side pipeline; see `Figure_2/SOURCE.md` |
| **Fig. S10** | `/CoGAPS` (`n30_cogaps_fGSEA.Rmd`) | GSEA heatmap plotted from deposited GSEA results |
| **Fig. S12** | `/LDSC` | dot plot; see `Figure_S12/SOURCE.md` |
| **Fig. S18 (E–F)** | `/LinearModel` | coefficient scatter; heatmaps A–D are local; see `Figure_S18/SOURCE.md` |

All other `Figure_*` units regenerate entirely from the deposited datasets and the script in their folder.
