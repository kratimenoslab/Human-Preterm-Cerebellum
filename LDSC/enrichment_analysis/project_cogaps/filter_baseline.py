#!/usr/bin/env python
"""
Filter baseline annotations to match the SNP set in bim files.
This creates filtered baseline files that are compatible with the custom annotations.
"""
import pandas as pd
import os

baseline_dir = "/home/ubuntu/childrens_ldsc/ref/baselineLD_v2.2"
bim_dir = "/home/ubuntu/childrens_ldsc/ref/plink_files_filtered"
output_dir = "/home/ubuntu/childrens_ldsc/ref/baselineLD_v2.2_filtered"

# Create output directory
os.makedirs(output_dir, exist_ok=True)

print(f"Filtering baseline annotations to match bim files...")
print(f"Output directory: {output_dir}")

for chrom in range(1, 23):
    print(f"\nProcessing chromosome {chrom}...")

    # Read bim file to get SNP list
    bim_file = f"{bim_dir}/1000G.EUR.hg38.{chrom}.bim"
    bim_df = pd.read_csv(bim_file, sep='\t', header=None,
                         names=['CHR', 'SNP', 'CM', 'BP', 'A1', 'A2'],
                         usecols=['SNP'])
    bim_snps = set(bim_df['SNP'])
    print(f"  BIM file: {len(bim_snps)} SNPs")

    # Read baseline annotation
    baseline_annot = f"{baseline_dir}/baselineLD.{chrom}.annot.gz"
    df_baseline = pd.read_csv(baseline_annot, sep='\t', compression='gzip')
    print(f"  Baseline annot (original): {len(df_baseline)} SNPs")

    # Filter to only include SNPs in bim file
    df_filtered = df_baseline[df_baseline['SNP'].isin(bim_snps)]
    print(f"  Baseline annot (filtered): {len(df_filtered)} SNPs")
    print(f"  Removed: {len(df_baseline) - len(df_filtered)} SNPs")

    # Save filtered annotation
    output_file = f"{output_dir}/baselineLD.{chrom}.annot.gz"
    df_filtered.to_csv(output_file, sep='\t', index=False, compression='gzip')
    print(f"  Saved: {output_file}")

    # Also need to filter the LD score files
    baseline_ldscore = f"{baseline_dir}/baselineLD.{chrom}.l2.ldscore.gz"
    df_ldscore = pd.read_csv(baseline_ldscore, sep='\t', compression='gzip')
    print(f"  Baseline ldscore (original): {len(df_ldscore)} SNPs")

    df_ldscore_filtered = df_ldscore[df_ldscore['SNP'].isin(bim_snps)]
    print(f"  Baseline ldscore (filtered): {len(df_ldscore_filtered)} SNPs")

    output_ldscore = f"{output_dir}/baselineLD.{chrom}.l2.ldscore.gz"
    df_ldscore_filtered.to_csv(output_ldscore, sep='\t', index=False, compression='gzip')
    print(f"  Saved: {output_ldscore}")

    # Copy M and M_5_50 files (these are just summary stats, not SNP-specific)
    import shutil
    for suffix in ['.l2.M', '.l2.M_5_50']:
        src = f"{baseline_dir}/baselineLD.{chrom}{suffix}"
        dst = f"{output_dir}/baselineLD.{chrom}{suffix}"
        shutil.copy(src, dst)
        print(f"  Copied: baselineLD.{chrom}{suffix}")

print("\nDone! Filtered baseline files created in:")
print(output_dir)
print("\nNow update ldsc_h2_jobs.pl to use the filtered baseline:")
print(f"$baseline2 = \"{output_dir}/baselineLD.\";")
