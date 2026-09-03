# Figure S9 C–E — single-gene spatial expression maps

Spatial feature plots of 12 marker genes (CBLN1, RELN, NEUROD1, ZIC2, SNAP25, CBLN3, VSNL1, CHGB,
CALB1, PCP2, ITPR1, ALDOC) on each of the 24 Visium capture areas (slides S3A–S8D; the same slide
prefixes as the spot identifiers in Data S4). The panels shown in fig. S9C–E are selected from this set.

- `plot_single_gene_expression.R` — the script that produced every plot (`Seurat::SpatialFeaturePlot`)
  from the processed Seurat object on the lab server (`<data_path>` placeholder). It is **not
  regenerable** from the deposited data: the Seurat object with the tissue images is server-side.
- `SCT/` — expression from the SCT-normalized assay (288 files).
- `log1pSpatial/` — log1p of the raw `Spatial` counts (288 files).

File naming: `Figure_S9_<GENE>_slide<ID>_<assay>.pdf`, e.g. `Figure_S9_CALB1_slideS3A_SCT.pdf`.
Colour scale: light blue (low) → grey → red (high); tissue image hidden (`image.alpha = 0`).
