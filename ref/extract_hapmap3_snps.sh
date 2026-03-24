#!/bin/bash
# Extract HapMap3 SNP lists from baseline LD score files

set -e

cd /home/ubuntu/childrens_ldsc/ref
mkdir -p hapmap3_snps

echo "=== Extracting HapMap3 SNP Lists ==="
echo "Using local baseline LD score files..."
echo ""

for i in {1..22}; do
    echo "Processing chromosome $i..."

    # Extract SNP column (column 2, skip header)
    zcat baselineLD_v2.2/baselineLD.$i.l2.ldscore.gz | awk 'NR>1 {print $2}' > hapmap3_snps/hm.$i.snp

    SNP_COUNT=$(wc -l < hapmap3_snps/hm.$i.snp)
    echo "  ✓ Created hm.$i.snp ($SNP_COUNT SNPs)"
done

echo ""
echo "=== Extraction Complete ==="
echo "Files created in: hapmap3_snps/"
echo ""
TOTAL_SNPS=$(cat hapmap3_snps/hm.*.snp | wc -l)
echo "Total SNPs across all chromosomes: $TOTAL_SNPS"
