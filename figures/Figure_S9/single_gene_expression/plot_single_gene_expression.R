library(Seurat)
library(ggplot2)
library(patchwork)

###################################################################################
###################################  LOAD DATA  ###################################
###################################################################################

seurat_obj <- load('<data_path>/human_sobj_transformed_projected.rda') # Version 4.0.2

# find images of interest
library(dplyr)
sobj@meta.data %>% select('patient','replicate','panels') %>%
  group_by(patient,replicate) %>%
  slice_head(n=1) %>%
  print(n = 24)

genes <- c("CBLN1","RELN","NEUROD1","ZIC2", 
           "SNAP25","CBLN3","VSNL1","CHGB", 
           "CALB1","PCP2","ITPR1","ALDOC") 


outputDir <- '<data_path>/featureplots/plots/20260903/'


###################################################################################
#################################  PLOT DATA SCT ##################################
###################################################################################


################################# SET 1 #################################
imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
#imgs <- c("S3A", "S5C")

for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 10000, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_SCT.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}


################################# SET 2 #################################
#imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
imgs <- c("S7A", "S3D", "S7D")
for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 8500, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_SCT.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}


################################# SET 3 #################################
#imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
imgs <- c("S8A", "S8D")
for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 2500, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_SCT.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}


################################# SET 4 #################################
#imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
imgs <- c("S8B")
for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 2200, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_SCT.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}



################################# SET 5 #################################
#imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
imgs <- c("S8C")
for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 2700, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_SCT.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}
























###################################################################################
##########################  PLOT DATA log1p spatial ###############################
###################################################################################
DefaultAssay(sobj) <- "Spatial"
cts <- GetAssayData(sobj, assay = "Spatial", slot = "counts")
logcts <- log1p(cts)
DefaultAssay(sobj) <- "Spatial"
  sobj <- SetAssayData(
    object   = sobj,
    assay    = "Spatial",
    slot     = "data", # changed this from layer to slot ?
    new.data = logcts
  )



################################# SET 1 #################################
imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
#imgs <- c("S3A", "S5C")

for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 10000, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_log1pSpatial.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}


################################# SET 2 #################################
#imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
imgs <- c("S7A", "S3D", "S7D")
for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 8500, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_log1pSpatial.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}


################################# SET 3 #################################
#imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
imgs <- c("S8A", "S8D")
for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 2500, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_log1pSpatial.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}


################################# SET 4 #################################
#imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
imgs <- c("S8B")
for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 2200, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_log1pSpatial.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}



################################# SET 5 #################################
#imgs <- tryCatch(Images(sobj), error = function(e) names(sobj@images))
#DefaultAssay(sobj) <- "Spatial"
imgs <- c("S8C")
for (gene in genes) {
  ##### CHECK GENE IN DATA ####
  if (!gene %in% rownames(sobj[[DefaultAssay(sobj)]])) {
    stop("Gene ", gene, " not found in assay: ", DefaultAssay(sobj))
  } else { print(paste("Plotting gene:", gene)) }

  ##### GENERATE PLOTS FOR GENE #####
  p_list <- SpatialFeaturePlot(
    sobj, features = gene,
    images = imgs,
    combine = FALSE,
    pt.size.factor = 2700, # https://github.com/satijalab/seurat/issues/8982
    alpha = c(0.5, 1),
    image.alpha = 0,
  )

  low_col  <- "#c7e6f3"  # light blue
  mid_col  <- "#d9d9d9"  # light gray
  high_col <- "#d73027"  # red

  p_list <- lapply(p_list, function(p) {
    p +
      ggplot2::scale_colour_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      ) +
      ggplot2::scale_fill_gradientn(
        colours = c(low_col, mid_col, high_col),
        values  = c(0, 0.5, 1),
        na.value = "white"
      )
  })

  ##### SAVE PLOTS (PDF) #####
  for (i in seq_along(p_list)) {
    out_i <- file.path(outputDir, paste0(gene, "_", imgs[i], "_log1pSpatial.pdf"))
    ggplot2::ggsave(
      filename = out_i,
      plot = p_list[[i]],
      width = 10, height = 10, units = "in",
      device = cairo_pdf  # better vector text; use device = "pdf" if cairo isn't available
    )
    cat("Saved:", out_i, "exists?", file.exists(out_i), "\n")
  }
}







