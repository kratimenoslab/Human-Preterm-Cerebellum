# Tables — reproducible code

Per-table reproduction code for the manuscript's computed supplementary tables. Each `Table_<n>/` folder
holds its script (`.Rmd` / `.R`) and its rendered self-contained report (`.html`).

## Data

As with the figures, scripts read the **de-identified Supplementary Data S1 to S5 published with the article**
through **relative paths only** (place the Data S1–S5 files, with Data S4 unzipped, in a
`Supplementary_Datasets/` folder at the repository root). No machine-
or user-specific path is embedded.

## Units

| Table | Contents | Source |
|---|---|---|
| **Table S3** | Effect of infant sex on the in-vivo analyses | self-contained |
| **Table S5** | GA group × PMA interaction in cranial-ultrasound growth | self-contained |
| **Table S9** | CMAP subgroup correlations vs GA / PMA | CMAP patterns from [`/CoGAPS`](../CoGAPS) |
| **Table S13** | Effect of infant sex on the postmortem layer analyses | self-contained |
| **Table S20** | Cross-modal CMAP ↔ neuropathology layer correlations | CMAP patterns from [`/CoGAPS`](../CoGAPS) |
