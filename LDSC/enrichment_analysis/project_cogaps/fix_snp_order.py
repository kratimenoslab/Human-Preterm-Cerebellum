#!/usr/bin/env python
"""
Reorder custom LD score files to match baseline SNP order.
This fixes the "LD Scores for concatenation must have identical SNP columns" error.
"""
import pandas as pd
import gzip
import glob
import os
import sys

baseline_dir = "/home/ubuntu/childrens_ldsc/ref/baselineLD_v2.2"
custom_dirs = glob.glob("out_Pattern_*")
# Filter out the *_2 directories (output directories)
custom_dirs = [d for d in custom_dirs if not d.endswith("_2")]

print(f"Found {len(custom_dirs)} custom annotation directories to fix")

for custom_dir in sorted(custom_dirs):
    print(f"\nProcessing {custom_dir}...")

    for chrom in range(1, 23):
        baseline_file = f"{baseline_dir}/baselineLD.{chrom}.l2.ldscore.gz"
        custom_file = f"{custom_dir}/chr.{chrom}.l2.ldscore.gz"

        if not os.path.exists(custom_file):
            print(f"  Warning: {custom_file} not found, skipping chr{chrom}")
            continue

        # Read baseline to get SNP order
        baseline_df = pd.read_csv(baseline_file, sep='\t', usecols=['CHR', 'SNP', 'BP'])

        # Read custom LD scores
        custom_df = pd.read_csv(custom_file, sep='\t')

        # Check if SNP sets match
        baseline_snps = set(baseline_df['SNP'])
        custom_snps = set(custom_df['SNP'])

        if baseline_snps != custom_snps:
            print(f"  ERROR: SNP sets don't match for chr{chrom}")
            print(f"    Baseline: {len(baseline_snps)}, Custom: {len(custom_snps)}")
            print(f"    Only in baseline: {len(baseline_snps - custom_snps)}")
            print(f"    Only in custom: {len(custom_snps - baseline_snps)}")
            continue

        # Merge to reorder custom by baseline order
        # We'll use baseline's CHR, SNP, BP order and merge in the L2 score from custom
        merged = baseline_df.merge(custom_df[['SNP', 'L2']], on='SNP', how='left')

        # Verify we didn't lose any SNPs
        if len(merged) != len(baseline_df):
            print(f"  ERROR: Lost SNPs during merge for chr{chrom}")
            continue

        if merged['L2'].isna().any():
            print(f"  ERROR: Missing L2 scores after merge for chr{chrom}")
            continue

        # Create backup
        backup_file = f"{custom_file}.backup"
        if not os.path.exists(backup_file):
            os.rename(custom_file, backup_file)
            print(f"  Created backup: {backup_file}")

        # Write reordered file
        merged.to_csv(custom_file, sep='\t', index=False, compression='gzip')
        print(f"  Fixed chr{chrom}: {len(merged)} SNPs reordered")

print("\nDone! Original files backed up with .backup extension")
print("You can now run your ldsc_h2_jobs.txt commands")
