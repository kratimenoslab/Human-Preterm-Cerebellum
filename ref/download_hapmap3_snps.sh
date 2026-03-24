#!/bin/bash
# Download HapMap3 SNP lists for LDSC
# These SNP lists are used in ldsc_score_jobs.pl

set -e  # Exit on error

# Create directory
mkdir -p hapmap3_snps
cd hapmap3_snps

echo "=== Downloading HapMap3 SNP Lists ==="
echo "Extracting SNP IDs from baseline LD score files..."
echo ""

BASE_URL="https://data.broadinstitute.org/alkesgroup/LDSCORE/1000G_Phase3_baselineLD_v2.2_ldscores"

for i in {1..22}; do
    echo "Processing chromosome $i..."

    # Download baseline LD score file for this chromosome
    wget -q $BASE_URL/baselineLD.$i.l2.ldscore.gz -O temp.$i.gz

    # Extract SNP column (column 2, skip header)
    zcat temp.$i.gz | awk 'NR>1 {print $2}' > hm.$i.snp

    # Clean up
    rm temp.$i.gz

    SNP_COUNT=$(wc -l < hm.$i.snp)
    echo "  ✓ Created hm.$i.snp ($SNP_COUNT SNPs)"
done

echo ""
echo "=== Download Complete ==="
echo "Files created in: $(pwd)"
echo ""
echo "Summary:"
ls -lh hm.*.snp
echo ""
TOTAL_SNPS=$(cat hm.*.snp | wc -l)
echo "Total SNPs across all chromosomes: $TOTAL_SNPS"
