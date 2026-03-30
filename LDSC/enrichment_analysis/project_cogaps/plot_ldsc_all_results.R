library(ggplot2)
library(dplyr)

# Read LDSC results
dat <- read.csv("ldsc_results.csv", row.names=1)

# Prepare data
dat <- dat %>%
  mutate(
    neg_log10_FDR = -log10(FDR),
    neg_log10_p = -log10(p_zcore),
    pattern = gsub("Pattern_", "P", cell),
    significant = ifelse(FDR < 0.05, "FDR < 0.05",
                  ifelse(p_zcore < 0.05, "p < 0.05", "n.s."))
  )

# Create bubble plot with ALL results, highlighting significant ones
p_all <- ggplot(dat, aes(x = pattern, y = trait)) +
  geom_point(aes(
    color = Coefficient_z.score,
    size = neg_log10_p,
    alpha = significant,
    shape = significant
  )) +
  scale_color_gradient2(
    low = "blue",
    mid = "grey90",
    high = "red",
    midpoint = 0,
    name = "Coefficient\nz-score"
  ) +
  scale_size_continuous(
    name = "-log10(p-value)",
    range = c(1, 8)
  ) +
  scale_alpha_manual(
    values = c("FDR < 0.05" = 1, "p < 0.05" = 0.7, "n.s." = 0.3),
    name = "Significance"
  ) +
  scale_shape_manual(
    values = c("FDR < 0.05" = 16, "p < 0.05" = 16, "n.s." = 1),
    name = "Significance"
  ) +
  labs(
    x = "CoGAPS Pattern",
    y = "Trait",
    title = "LDSC Partitioned Heritability Enrichment - All Results",
    subtitle = "Circle size = -log10(p), filled circles = significant"
  ) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major = element_line(color = "grey90"),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )

ggsave("ldsc_all_results.pdf", p_all, width = 12, height = 7)
ggsave("ldsc_all_results.png", p_all, width = 12, height = 7, dpi = 300)

cat("All results plot saved\n")

# Summary statistics
cat("\n=== SUMMARY ===\n")
cat(sprintf("Total tests: %d\n", nrow(dat)))
cat(sprintf("Significant at FDR < 0.05: %d (%.1f%%)\n",
            sum(dat$FDR < 0.05),
            100 * mean(dat$FDR < 0.05)))
cat(sprintf("Significant at p < 0.05: %d (%.1f%%)\n",
            sum(dat$p_zcore < 0.05),
            100 * mean(dat$p_zcore < 0.05)))

# Top enrichments
cat("\n=== TOP 10 ENRICHMENTS (by z-score) ===\n")
print(dat %>%
  arrange(desc(abs(Coefficient_z.score))) %>%
  head(10) %>%
  select(pattern, trait, Enrichment, Coefficient_z.score, p_zcore, FDR))

# Significant results
if(sum(dat$FDR < 0.05) > 0) {
  cat("\n=== SIGNIFICANT ENRICHMENTS (FDR < 0.05) ===\n")
  print(dat %>%
    filter(FDR < 0.05) %>%
    arrange(FDR) %>%
    select(pattern, trait, Enrichment, Coefficient_z.score, p_zcore, FDR))
} else {
  cat("\nNo results with FDR < 0.05\n")
}

# Pattern-specific summary
cat("\n=== ENRICHMENTS BY PATTERN ===\n")
pattern_summary <- dat %>%
  group_by(pattern) %>%
  summarise(
    n_sig_FDR = sum(FDR < 0.05),
    n_sig_p = sum(p_zcore < 0.05),
    mean_enrichment = mean(Enrichment),
    max_zscore = max(abs(Coefficient_z.score))
  ) %>%
  arrange(desc(n_sig_FDR))

print(pattern_summary)
