#!/usr/bin/env python
"""
Fix chromosome 7 by adding missing SNPs with L2=0
"""
import pandas as pd
import glob

baseline_dir = "/home/ubuntu/childrens_ldsc/ref/baselineLD_v2.2"
custom_dirs = glob.glob("out_Pattern_*")
custom_dirs = [d for d in custom_dirs if not d.endswith("_2")]

print(f"Fixing chromosome 7 for {len(custom_dirs)} patterns...")

for custom_dir in sorted(custom_dirs):
    baseline_file = f"{baseline_dir}/baselineLD.7.l2.ldscore.gz"
    custom_file = f"{custom_dir}/chr.7.l2.ldscore.gz"

    # Read baseline to get all SNPs
    baseline_df = pd.read_csv(baseline_file, sep='\t', usecols=['CHR', 'SNP', 'BP'])

    # Read custom LD scores
    custom_df = pd.read_csv(custom_file, sep='\t')

    # Merge - left join to keep all baseline SNPs
    merged = baseline_df.merge(custom_df[['SNP', 'L2']], on='SNP', how='left')

    # Fill missing L2 values with 0 (SNP not in annotation)
    merged['L2'].fillna(0.0, inplace=True)

    # Create backup
    import os
    backup_file = f"{custom_file}.backup"
    if not os.path.exists(backup_file):
        os.rename(custom_file, backup_file)
        print(f"  {custom_dir}: Created backup, added {merged['L2'].isna().sum()} missing SNPs with L2=0")

    # Write fixed file
    merged.to_csv(custom_file, sep='\t', index=False, compression='gzip')
    print(f"  {custom_dir}: Fixed chr7 with {len(merged)} SNPs")

print("\nDone!")
