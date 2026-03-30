#!/usr/bin/env python3
"""
Convert UKB imaging files with pval(-log10) to files with regular P values.
Input:  <id>.txt with pval(-log10) column
Output: <id>.unlogP.txt with P column
"""

import os
import sys
from pathlib import Path

def convert_log10_pvalue(pval_log10):
    """Convert -log10(p) back to p-value: p = 10^(-pval)"""
    try:
        return 10 ** (-float(pval_log10))
    except (ValueError, OverflowError):
        return float('nan')

def process_file(input_file, output_file):
    """Process a single UKB imaging file"""
    print(f"Processing {input_file.name}...")

    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        # Read header (space-separated)
        header = infile.readline().strip().split()

        # Find the pval(-log10) column index
        try:
            pval_idx = header.index('pval(-log10)')
        except ValueError:
            print(f"  ERROR: Could not find 'pval(-log10)' column in {input_file.name}")
            print(f"  Available columns: {header}")
            return False

        # Write new header with P column (space-separated)
        new_header = header + ['P']
        outfile.write(' '.join(new_header) + '\n')

        # Process data rows
        line_count = 0
        for line in infile:
            line_count += 1
            fields = line.strip().split()

            if len(fields) != len(header):
                print(f"  WARNING: Line {line_count + 1} has {len(fields)} fields, expected {len(header)}")
                continue

            # Convert -log10(p) to p
            pval_log10 = fields[pval_idx]
            p_value = convert_log10_pvalue(pval_log10)

            # Write original fields plus new P value (space-separated)
            new_fields = fields + [str(p_value)]
            outfile.write(' '.join(new_fields) + '\n')

        print(f"  Converted {line_count} variants")

    return True

def main():
    # Directory containing imaging files
    imaging_dir = Path.home() / 'dale' / 'ref' / 'childrens_unsummed_gwas' / 'ukb_imaging'

    if not imaging_dir.exists():
        print(f"ERROR: Directory not found: {imaging_dir}")
        sys.exit(1)

    # Find all .txt files (but not .unlogP.txt files)
    input_files = sorted([f for f in imaging_dir.glob('*.txt')
                          if not f.name.endswith('.unlogP.txt')])

    if not input_files:
        print(f"ERROR: No .txt files found in {imaging_dir}")
        sys.exit(1)

    print(f"Found {len(input_files)} files to process")
    print("=" * 60)

    success_count = 0
    for input_file in input_files:
        # Create output filename: <id>.unlogP.txt
        file_id = input_file.stem  # e.g., "0021"
        output_file = imaging_dir / f"{file_id}.unlogP.txt"

        if process_file(input_file, output_file):
            success_count += 1

    print("=" * 60)
    print(f"Successfully converted {success_count}/{len(input_files)} files")
    print(f"Output files: {imaging_dir}/*.unlogP.txt")

if __name__ == '__main__':
    main()
