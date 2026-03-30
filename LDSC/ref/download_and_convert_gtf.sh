#!/bin/bash
# Download GENCODE hg38 GTF and convert to gene_meta_hg38.txt format

set -e  # Exit on error

echo "=== Downloading GENCODE v46 (hg38) GTF file ==="
echo "This will download ~60 MB compressed file"
echo ""

# Download GENCODE v46 annotation
if [ ! -f "gencode.v46.annotation.gtf.gz" ]; then
    echo "Downloading gencode.v46.annotation.gtf.gz..."
    wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.annotation.gtf.gz
    echo "✓ Download complete"
else
    echo "✓ gencode.v46.annotation.gtf.gz already exists, skipping download"
fi

echo ""
echo "=== Converting GTF to gene_meta_hg38.txt format ==="
echo ""

# Run R script to convert
Rscript convert_gtf_to_gene_meta.R

echo ""
echo "=== All done! ==="
echo "Output file: gene_meta_hg38.txt"
echo ""
echo "Next steps:"
echo "1. Verify the file looks correct: head gene_meta_hg38.txt"
echo "2. Update the path in project_all/bedfiles/bed.R (line 4)"
echo "   gene.anno.file <- here(\"ref/gene_meta_hg38.txt\")"
