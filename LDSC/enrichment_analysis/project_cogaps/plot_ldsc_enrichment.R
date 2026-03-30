library(ggplot2)
library(dplyr)
library(here)

# Read LDSC results
dat <- read.csv(here("enrichment_analysis/project_cogaps/ldsc_results_cogaps.csv"), row.names=1)

# Filter for significant results (FDR < 0.05)
dat_sig <- dat %>%
  filter(FDR < 0.05) %>%
  mutate(
    neg_log10_FDR = -log10(FDR),
    # Clean up pattern names for plotting
    pattern = gsub("Pattern_", "P", cell)
  )

# Check if we have significant results
if(nrow(dat_sig) == 0) {
  cat("No significant results found with FDR < 0.05\n")
  cat("Consider using a less stringent threshold (e.g., p < 0.05) for visualization\n")

  # Alternative: show top results by p-value
  dat_sig <- dat %>%
    arrange(p_zcore) %>%
    head(20) %>%
    mutate(
      neg_log10_FDR = -log10(FDR),
      pattern = gsub("Pattern_", "P", cell)
    )
  cat(sprintf("Showing top %d results by p-value instead\n", nrow(dat_sig)))
}

# Create bubble plot
p <- ggplot(dat_sig, aes(x = pattern, y = trait)) +
  geom_point(aes(
    color = Coefficient_z.score,
    size = neg_log10_FDR
  )) +
  scale_color_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    midpoint = 0,
    name = "Coefficient\nz-score"
  ) +
  scale_size_continuous(
    name = "-log10(FDR)",
    range = c(2, 10)
  ) +
  labs(
    x = "CoGAPS Pattern",
    y = "Trait",
    title = "LDSC Partitioned Heritability Enrichment",
    subtitle = paste0("Significant results (FDR < 0.05), n = ", nrow(dat_sig))
  ) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major = element_line(color = "grey90"),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )

# Save plot
ggsave(here("enrichment_analysis/project_cogaps/ldsc_enrichment_bubble_cogaps.pdf"), p, width = 10, height = 6)
ggsave(here("enrichment_analysis/project_cogaps/ldsc_enrichment_bubble_cogaps.png"), p, width = 10, height = 6, dpi = 300)

cat("Plots saved as ldsc_enrichment_bubble.pdf and .png\n")

# Print summary
cat("\nSummary of significant enrichments:\n")
print(dat_sig %>%
  dplyr::select(pattern, trait, Enrichment, Coefficient_z.score, FDR) %>%
  arrange(FDR))

# Optional: Create heatmap version
p_heatmap <- ggplot(dat_sig, aes(x = pattern, y = trait)) +
  geom_tile(aes(fill = Coefficient_z.score), color = "white") +
  geom_text(aes(label = ifelse(FDR < 0.01, "**",
                        ifelse(FDR < 0.05, "*", ""))),
            size = 6) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    midpoint = 0,
    name = "Coefficient\nz-score"
  ) +
  labs(
    x = "CoGAPS Pattern",
    y = "Trait",
    title = "LDSC Enrichment Heatmap",
    subtitle = "* FDR < 0.05, ** FDR < 0.01"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(here("enrichment_analysis/project_cogaps/ldsc_enrichment_heatmap_cogaps.pdf"), p_heatmap, width = 8, height = 5)
ggsave(here("enrichment_analysis/project_cogaps/ldsc_enrichment_heatmap_cogaps.png"), p_heatmap, width = 8, height = 5, dpi = 300)

cat("Heatmap saved as ldsc_enrichment_heatmap_cogaps.pdf and .png\n")

