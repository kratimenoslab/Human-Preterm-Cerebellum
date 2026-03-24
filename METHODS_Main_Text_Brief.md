# Methods
**Character count: ~800 **

---

## Partitioned Heritability Enrichment Analysis

We tested whether cerebellar gene expression patterns were enriched for genetic variants associated with brain traits using LD score regression (LDSC) (1,2). CoGAPS (3) identified 28 gene expression patterns from bulk cerebellar transcriptomic data. For each pattern, genes in the top 10th percentile of pattern weights were mapped to genomic coordinates (hg38) with ±100 kb regulatory windows. These regions were converted to binary annotations for LD score computation using 1000 Genomes Phase 3 European ancestry reference genotypes (4), conditioned on the baseline LD model v2.2 (97 functional annotations) (16). We performed partitioned heritability regression for 76 GWAS traits, including psychiatric and neurological disorders, cognitive traits, brain imaging phenotypes (UK Biobank), and non-brain control traits (5-15). Enrichment was defined as the proportion of SNP heritability explained by a pattern divided by the proportion of SNPs in that pattern. Significance was assessed using Benjamini-Hochberg false discovery rate (FDR) correction across 2,128 tests (28 patterns × 76 traits), with FDR < 0.05 considered significant. Detailed methods and GWAS references are provided in the Supplementary Materials.

---

## Figure Legend

**Figure X. Partitioned heritability enrichment of cerebellar gene expression patterns.**


Bubble plot highlighting significant pattern-trait enrichments (FDR < 0.05). Bubble size reflects -log₁₀(FDR), color indicates enrichment magnitude. Pattern [X] shows strongest enrichment for [trait].



---

## Table Legend

**Table #. LDSC partitioned heritability enrichment results.**

| Pattern | Trait | Prop. SNPs | Prop. h² | Enrichment | Enrichment SE | Enrichment P | FDR |
|---------|-------|------------|----------|------------|---------------|--------------|-----|
| Pattern_1 | Alzheimer's | 0.182 | 0.329 | 1.81 | 0.33 | 0.003 | 0.041 |
| ... | ... | ... | ... | ... | ... | ... | ... |

Columns: Pattern = CoGAPS pattern ID; Trait = GWAS phenotype; Prop. SNPs = proportion of genome-wide SNPs in pattern annotation; Prop. h² = proportion of SNP heritability explained by pattern; Enrichment = (Prop. h² / Prop. SNPs); SE = standard error; P = one-sided p-value; FDR = Benjamini-Hochberg false discovery rate.

---

## References (numbered for main text)

1. Bulik-Sullivan et al. (2015) Nat Genet 47:291-295
2. Finucane et al. (2015) Nat Genet 47:1228-1235
3. Stein-O'Brien et al. (2018) Trends Genet 34:790-805
4. 1000 Genomes Project Consortium (2015) Nature 526:68-74
5. Grove J et al. (2019) Nat Genet 51:431-444 (PMID: 30804558) — ASD
6. Demontis D et al. (2023) Nat Genet 55:198-208 (PMID: 36702997) — ADHD
7. Chambers T et al. (2022) Mol Psychiatry 27:2282-2290 (PMID: 35079123) — cerebellar volume
8. Tissink E et al. (2022) Commun Biol 5:710 (PMID: 35842455) — cerebellar volume
9. Smith SM et al. (2021) Nat Neurosci 24:737-745 (PMID: 33875891) — UK Biobank brain IDPs (BIG40)
10. Carrion-Castillo A & Boeckx C (2024) Sci Rep 14:9488 (PMID: 38664414) — cerebellar lobule volumes
11. Savage JE et al. (2018) Nat Genet 50:912-919 (PMID: 29942086) — intelligence
12. Davies G et al. (2018) Nat Commun 9:2098 (PMID: 29844566) — reaction time / general cognitive function
13. Lee JJ et al. (2018) Nat Genet 50:1112-1121 (PMID: 30038396) — educational attainment
14. Huang QQ et al. (2024) Nature 636:404-411 (PMID: 39567701) — rare neurodevelopmental conditions
15. Gui A et al. (2025) Nat Hum Behav 9:1470-1487 (PMID: 40335706) — age at onset of walking
16. Gazal et al. (2017) Nat Genet 49:1421-1427
