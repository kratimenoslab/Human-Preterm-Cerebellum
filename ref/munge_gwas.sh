#!/bin/bash
# Munge GWAS summary statistics for LDSC enrichment analysis
# Run from within ldsc conda environment
# Usage: bash munge_gwas.sh
#
# Sample sizes:
#   Tissink cerebellar:  N=27,486 (discovery) - has N column in file
#   Tissink subcortical: N=27,486 (discovery) - has N column in file
#   Tissink cerebral:    N=27,486 (discovery) - has N column in file
#   ASD (iPSYCH-PGC):    N=18,381 cases + 27,969 controls
#   ADHD 2022:           N=38,691 cases + 186,843 controls - has Nca/Nco columns
#   Intelligence 2018:   N=269,867 (meta-analysis) - has N_analyzed column
#   Davies RT 2018:      N=300,486 (UK Biobank)

LDSC_DIR=~/dale/src/ldsc
INPUT_DIR=~/dale/ref/childrens_unsummed_gwas
OUTPUT_DIR=~/dale/ref/childrens_summarized_gwas

# Create output directory
mkdir -p ${OUTPUT_DIR}

# Track progress
TOTAL=49
COMPLETED=0
SKIPPED=0
FAILED=0

echo "=========================================="
echo "Munging GWAS Summary Statistics for LDSC"
echo "=========================================="
echo ""

# ==============================================================================
# 1. Tissink 2022 - Cerebellar Volume (use MAF 0.005)
# ==============================================================================
echo "[1/49] Tissink 2022 - Cerebellar Volume (MAF 0.005)"
if [ -f ${OUTPUT_DIR}/Tissink_cerebellar.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/Tissink_2022/Tissinketal_CommBio2022_cerebellarvolume.txt \
    --out ${OUTPUT_DIR}/Tissink_cerebellar \
    --maf-min 0.005 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 2. Tissink 2022 - Subcortical Volume
# ==============================================================================
echo ""
echo "[2/49] Tissink 2022 - Subcortical Volume"
if [ -f ${OUTPUT_DIR}/Tissink_subcortical.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/Tissink_2022/Tissinketal_CommBio2022_subcorticalvolume.txt \
    --out ${OUTPUT_DIR}/Tissink_subcortical && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 3. Chambers - Total Cerebellar Volume
# ==============================================================================
echo ""
echo "[3/49] Chambers - Total Cerebellar Volume"
if [ -f ${OUTPUT_DIR}/Chambers_total_cerebellar_volume.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/Chambers_total_cerebellar_volume_GCST90020190_buildGRCh37.tsv \
    --out ${OUTPUT_DIR}/Chambers_total_cerebellar_volume \
    --snp variant_id \
    --a1 effect_allele \
    --a2 other_allele \
    --signed-sumstats beta,0 \
    --N 33265 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 4. iPSYCH-PGC 2017 - ASD
# ==============================================================================
echo ""
echo "[4/49] iPSYCH-PGC 2017 - ASD"
if [ -f ${OUTPUT_DIR}/ASD_2017.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/14671989/iPSYCH-PGC_ASD_Nov2017 \
    --out ${OUTPUT_DIR}/ASD_2017 \
    --N-cas 18381 \
    --N-con 27969 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 5. ADHD 2022
# ==============================================================================
echo ""
echo "[5/49] ADHD 2022"
if [ -f ${OUTPUT_DIR}/ADHD_2022.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/22564390/ADHD2022_iPSYCH_deCODE_PGC.meta \
    --out ${OUTPUT_DIR}/ADHD_2022 \
    --N-cas-col Nca \
    --N-con-col Nco \
    --frq FRQ_A_38691 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 6. Savage & Jansen 2018 - Intelligence
# # DLB. georgio asked to change the file name to cognition-intelligence
# ==============================================================================
echo ""
echo "[6/49] Savage & Jansen 2018 - Intelligence"
if [ -f ${OUTPUT_DIR}/Intelligence_2018.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/SavageJansen_2018_intelligence_metaanalysis.txt \
    --out ${OUTPUT_DIR}/Savage_cognition_intelligence \
    --N-col N_analyzed \
    --frq EAF_HRC \
    --info minINFO \
    --signed-sumstats Zscore,0 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 7. Davies 2018 - Reaction Time
# ==============================================================================
echo ""
echo "[7/49] Davies 2018 - Reaction Time"
if [ -f ${OUTPUT_DIR}/Davies_RT_2018.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/Davies2018_UKB_RT_summary_results_29052018.txt.gz \
    --out ${OUTPUT_DIR}/Davies_RT_2018 \
    --snp MarkerName \
    --a1 Effect_allele \
    --a2 Other_allele \
    --signed-sumstats Beta,0 \
    --N 300486 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 8. Huang 2024 - Neurodevelopmental Meta-analysis
# ==============================================================================
echo ""
echo "[8/49] Huang 2024 - Neurodevelopmental Meta-analysis"
if [ -f ${OUTPUT_DIR}/Huang_neurodev_meta.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/Huang2024_supplementary_data3_GWAS_meta.txt \
    --out ${OUTPUT_DIR}/Huang_neurodev_meta \
    --a1 effect_allele \
    --a2 other_allele \
    --signed-sumstats beta,0 \
    --N-cas 10015 \
    --N-con 22937 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 9. Gui 2025 - Age of Onset Walking
# ==============================================================================
echo ""
echo "[9/49] Gui 2025 - Age of Onset Walking"
if [ -f ${OUTPUT_DIR}/Gui_age_onset_walking.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/Gui2025_AOWgwas_sumstats.txt \
    --out ${OUTPUT_DIR}/Gui_age_onset_walking \
    --a1 A1 \
    --a2 A2 \
    --signed-sumstats b,0 \
    --N-col N && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 10. Lee 2018 - Cognitive Performance
# ==============================================================================
echo ""
echo "[10/49] Lee 2018 - Cognitive Performance"
if [ -f ${OUTPUT_DIR}/Lee_cognitive_performance.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/Lee2018_GWAS_CP_all.txt \
    --out ${OUTPUT_DIR}/Lee_cognitive_performance \
    --snp MarkerName \
    --a1 A1 \
    --a2 A2 \
    --signed-sumstats Beta,0 \
    --N 1311438 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 11. Lee 2018 - Educational Attainment (excl 23andMe)
# ==============================================================================
echo ""
echo "[11/49] Lee 2018 - Educational Attainment (excl 23andMe)"
if [ -f ${OUTPUT_DIR}/Lee_educ_attainment.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/Lee2018_GWAS_EA_excl23andMe.txt \
    --out ${OUTPUT_DIR}/Lee_educ_attainment \
    --snp MarkerName \
    --a1 A1 \
    --a2 A2 \
    --signed-sumstats Beta,0 \
    --N 1311438 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 13. UKB Imaging - Volume_of_left_amygdala
# ==============================================================================
echo ""
echo "[13/${TOTAL}] UKB Imaging - Volume_of_left_amygdala"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0021_Volume_of_left_amygdala.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0021.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0021_Volume_of_left_amygdala \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 14. UKB Imaging - Volume_of_right_accumbens
# ==============================================================================
echo ""
echo "[14/${TOTAL}] UKB Imaging - Volume_of_right_accumbens"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0024_Volume_of_right_accumbens.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0024.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0024_Volume_of_right_accumbens \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 15. UKB Imaging - Volume_of_grey_matter_in_Left_Frontal_Pole
# ==============================================================================
echo ""
echo "[15/${TOTAL}] UKB Imaging - Volume_of_grey_matter_in_Left_Frontal_Pole"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0026_Volume_of_grey_matter_in_Left_Frontal_Pole.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0026.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0026_Volume_of_grey_matter_in_Left_Frontal_Pole \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 16. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_I-IV
# ==============================================================================
echo ""
echo "[16/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_I-IV"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0137_IDP_T1_FAST_ROIs_L_cerebellum_I-IV.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0137.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0137_IDP_T1_FAST_ROIs_L_cerebellum_I-IV \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 17. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_I-IV
# ==============================================================================
echo ""
echo "[17/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_I-IV"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0138_IDP_T1_FAST_ROIs_R_cerebellum_I-IV.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0138.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0138_IDP_T1_FAST_ROIs_R_cerebellum_I-IV \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 18. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_V
# ==============================================================================
echo ""
echo "[18/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_V"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0139_IDP_T1_FAST_ROIs_L_cerebellum_V.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0139.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0139_IDP_T1_FAST_ROIs_L_cerebellum_V \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 19. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_V
# ==============================================================================
echo ""
echo "[19/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_V"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0140_IDP_T1_FAST_ROIs_R_cerebellum_V.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0140.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0140_IDP_T1_FAST_ROIs_R_cerebellum_V \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 20. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_VI
# ==============================================================================
echo ""
echo "[20/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_VI"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0141_IDP_T1_FAST_ROIs_L_cerebellum_VI.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0141.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0141_IDP_T1_FAST_ROIs_L_cerebellum_VI \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 21. UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_VI
# ==============================================================================
echo ""
echo "[21/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_VI"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0142_IDP_T1_FAST_ROIs_V_cerebellum_VI.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0142.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0142_IDP_T1_FAST_ROIs_V_cerebellum_VI \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 22. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_VI
# ==============================================================================
echo ""
echo "[22/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_VI"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0143_IDP_T1_FAST_ROIs_R_cerebellum_VI.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0143.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0143_IDP_T1_FAST_ROIs_R_cerebellum_VI \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 23. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_crus_I
# ==============================================================================
echo ""
echo "[23/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_crus_I"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0144_IDP_T1_FAST_ROIs_L_cerebellum_crus_I.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0144.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0144_IDP_T1_FAST_ROIs_L_cerebellum_crus_I \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 24. UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_crus_I
# ==============================================================================
echo ""
echo "[24/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_crus_I"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0145_IDP_T1_FAST_ROIs_V_cerebellum_crus_I.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0145.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0145_IDP_T1_FAST_ROIs_V_cerebellum_crus_I \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 25. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_crus_I
# ==============================================================================
echo ""
echo "[25/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_crus_I"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0146_IDP_T1_FAST_ROIs_R_cerebellum_crus_I.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0146.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0146_IDP_T1_FAST_ROIs_R_cerebellum_crus_I \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 26. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_crus_II
# ==============================================================================
echo ""
echo "[26/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_crus_II"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0147_IDP_T1_FAST_ROIs_L_cerebellum_crus_II.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0147.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0147_IDP_T1_FAST_ROIs_L_cerebellum_crus_II \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 27. UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_crus_II
# ==============================================================================
echo ""
echo "[27/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_crus_II"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0148_IDP_T1_FAST_ROIs_V_cerebellum_crus_II.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0148.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0148_IDP_T1_FAST_ROIs_V_cerebellum_crus_II \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 28. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_crus_II
# ==============================================================================
echo ""
echo "[28/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_crus_II"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0149_IDP_T1_FAST_ROIs_R_cerebellum_crus_II.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0149.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0149_IDP_T1_FAST_ROIs_R_cerebellum_crus_II \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 29. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_VIIb
# ==============================================================================
echo ""
echo "[29/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_VIIb"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0150_IDP_T1_FAST_ROIs_L_cerebellum_VIIb.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0150.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0150_IDP_T1_FAST_ROIs_L_cerebellum_VIIb \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 30. UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_VIIb
# ==============================================================================
echo ""
echo "[30/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_VIIb"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0151_IDP_T1_FAST_ROIs_V_cerebellum_VIIb.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0151.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0151_IDP_T1_FAST_ROIs_V_cerebellum_VIIb \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 31. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_VIIb
# ==============================================================================
echo ""
echo "[31/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_VIIb"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0152_IDP_T1_FAST_ROIs_R_cerebellum_VIIb.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0152.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0152_IDP_T1_FAST_ROIs_R_cerebellum_VIIb \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 32. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_VIIIa
# ==============================================================================
echo ""
echo "[32/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_VIIIa"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0153_IDP_T1_FAST_ROIs_L_cerebellum_VIIIa.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0153.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0153_IDP_T1_FAST_ROIs_L_cerebellum_VIIIa \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 33. UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_VIIIa
# ==============================================================================
echo ""
echo "[33/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_VIIIa"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0154_IDP_T1_FAST_ROIs_V_cerebellum_VIIIa.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0154.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0154_IDP_T1_FAST_ROIs_V_cerebellum_VIIIa \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 34. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_VIIIa
# ==============================================================================
echo ""
echo "[34/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_VIIIa"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0155_IDP_T1_FAST_ROIs_R_cerebellum_VIIIa.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0155.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0155_IDP_T1_FAST_ROIs_R_cerebellum_VIIIa \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 35. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_VIIIb
# ==============================================================================
echo ""
echo "[35/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_VIIIb"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0156_IDP_T1_FAST_ROIs_L_cerebellum_VIIIb.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0156.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0156_IDP_T1_FAST_ROIs_L_cerebellum_VIIIb \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 36. UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_VIIIb
# ==============================================================================
echo ""
echo "[36/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_VIIIb"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0157_IDP_T1_FAST_ROIs_V_cerebellum_VIIIb.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0157.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0157_IDP_T1_FAST_ROIs_V_cerebellum_VIIIb \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 37. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_VIIIb
# ==============================================================================
echo ""
echo "[37/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_VIIIb"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0158_IDP_T1_FAST_ROIs_R_cerebellum_VIIIb.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0158.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0158_IDP_T1_FAST_ROIs_R_cerebellum_VIIIb \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 38. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_IX
# ==============================================================================
echo ""
echo "[38/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_IX"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0159_IDP_T1_FAST_ROIs_L_cerebellum_IX.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0159.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0159_IDP_T1_FAST_ROIs_L_cerebellum_IX \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 39. UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_IX
# ==============================================================================
echo ""
echo "[39/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_IX"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0160_IDP_T1_FAST_ROIs_V_cerebellum_IX.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0160.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0160_IDP_T1_FAST_ROIs_V_cerebellum_IX \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 40. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_IX
# ==============================================================================
echo ""
echo "[40/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_IX"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0161_IDP_T1_FAST_ROIs_R_cerebellum_IX.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0161.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0161_IDP_T1_FAST_ROIs_R_cerebellum_IX \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 41. UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_X
# ==============================================================================
echo ""
echo "[41/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_L_cerebellum_X"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0162_IDP_T1_FAST_ROIs_L_cerebellum_X.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0162.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0162_IDP_T1_FAST_ROIs_L_cerebellum_X \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 42. UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_X
# ==============================================================================
echo ""
echo "[42/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_V_cerebellum_X"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0163_IDP_T1_FAST_ROIs_V_cerebellum_X.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0163.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0163_IDP_T1_FAST_ROIs_V_cerebellum_X \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 43. UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_X
# ==============================================================================
echo ""
echo "[43/${TOTAL}] UKB Imaging - IDP_T1_FAST_ROIs_R_cerebellum_X"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0164_IDP_T1_FAST_ROIs_R_cerebellum_X.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0164.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0164_IDP_T1_FAST_ROIs_R_cerebellum_X \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 44. UKB Imaging - aseg_lh_volume_Cerebellum-White-Matter
# ==============================================================================
echo ""
echo "[44/${TOTAL}] UKB Imaging - aseg_lh_volume_Cerebellum-White-Matter"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0193_aseg_lh_volume_Cerebellum-White-Matter.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0193.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0193_aseg_lh_volume_Cerebellum-White-Matter \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 45. UKB Imaging - aseg_lh_volume_Cerebellum-Cortex
# ==============================================================================
echo ""
echo "[45/${TOTAL}] UKB Imaging - aseg_lh_volume_Cerebellum-Cortex"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0194_aseg_lh_volume_Cerebellum-Cortex.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0194.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0194_aseg_lh_volume_Cerebellum-Cortex \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 46. UKB Imaging - aseg_rh_volume_Cerebellum-White-Matter
# ==============================================================================
echo ""
echo "[46/${TOTAL}] UKB Imaging - aseg_rh_volume_Cerebellum-White-Matter"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0210_aseg_rh_volume_Cerebellum-White-Matter.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0210.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0210_aseg_rh_volume_Cerebellum-White-Matter \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 47. UKB Imaging - aseg_rh_volume_Cerebellum-Cortex
# ==============================================================================
echo ""
echo "[47/${TOTAL}] UKB Imaging - aseg_rh_volume_Cerebellum-Cortex"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0211_aseg_rh_volume_Cerebellum-Cortex.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0211.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0211_aseg_rh_volume_Cerebellum-Cortex \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 48. UKB Imaging - Volume_of_V1_in_the_right_hemisphere
# ==============================================================================
echo ""
echo "[48/${TOTAL}] UKB Imaging - Volume_of_V1_in_the_right_hemisphere"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0434_Volume_of_V1_in_the_right_hemisphere.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0434.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0434_Volume_of_V1_in_the_right_hemisphere \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# 49. UKB Imaging - Volume_of_entorhinal_in_the_left_hemisphere_DKT_parcellation
# ==============================================================================
echo ""
echo "[49/${TOTAL}] UKB Imaging - Volume_of_entorhinal_in_the_left_hemisphere_DKT_parcellation"
if [ -f ${OUTPUT_DIR}/UKB_IDP_0442_Volume_of_entorhinal_in_the_left_hemisphere_DKT_parcellation.sumstats.gz ]; then
  echo "  ✓ Already exists, skipping..."
  ((SKIPPED++))
else
  python ${LDSC_DIR}/munge_sumstats.py \
    --sumstats ${INPUT_DIR}/ukb_imaging/0442.unlogP.txt \
    --out ${OUTPUT_DIR}/UKB_IDP_0442_Volume_of_entorhinal_in_the_left_hemisphere_DKT_parcellation \
    --snp rsid \
    --a1 a1 \
    --a2 a2 \
    --signed-sumstats beta,0 \
    --N 33404 && ((COMPLETED++)) || ((FAILED++))
fi

# ==============================================================================
# Summary
# ==============================================================================
echo ""
echo "=========================================="
echo "Munging Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  Total datasets:    $TOTAL"
echo "  Newly completed:   $COMPLETED"
echo "  Skipped (exists):  $SKIPPED"
echo "  Failed:            $FAILED"
echo ""
if [ $FAILED -gt 0 ]; then
  echo "⚠️  Some datasets failed - check output above for errors"
  echo ""
fi
echo "Output files in: ${OUTPUT_DIR}/"
ls -1 ${OUTPUT_DIR}/*.sumstats.gz 2>/dev/null | sed 's|.*/|  - |' || echo "  (no files yet)"
echo ""
