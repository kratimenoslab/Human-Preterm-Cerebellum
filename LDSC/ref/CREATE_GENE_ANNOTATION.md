# Creating the Gene Annotation File (gene_meta_hg19.txt)

The LDSC pipeline requires a gene annotation file that maps gene names to genomic coordinates in hg19 (GRCh37) build.

## Quick Method: Automated Download & Conversion

```bash
cd enrichment_analysis

# Run the automated script (downloads GTF and converts it)
bash download_and_convert_gtf.sh
```

This will:
1. Download GENCODE v19 GTF file (~40 MB)
2. Convert it to the required format
3. Create `gene_meta_hg19.txt`

**Time:** ~2-5 minutes

---

## Manual Method: If You Already Have a GTF File

If you already have an hg19/GRCh37 GTF file:

```bash
cd enrichment_analysis

# Edit convert_gtf_to_gene_meta.R
# Update line 13 with your GTF file path:
# gtf_file <- "path/to/your/file.gtf.gz"

# Run conversion
Rscript convert_gtf_to_gene_meta.R
```

---

## Required Format

The output file must be **tab-separated** with these columns:

```
Gene.name    Chromosome    Start    End
APOE         19            45409011    45412650
BDNF         11            27654894    27722628
GRIN2B       12            13533524    13855416
...
```

**Important specifications:**
- **Header row:** Required with exact column names
- **Separator:** Tab character (not spaces)
- **Chromosome:** Numbers only (1-22, X, Y, MT) - no "chr" prefix
- **Coordinates:** Integer positions (0-based or 1-based, pipeline handles both)
- **Gene names:** Standard HGNC gene symbols
- **One gene per row:** No duplicates

---

## Verification

After creating the file, verify it's correct:

```bash
# Check format
head gene_meta_hg19.txt

# Expected output:
# Gene.name    Chromosome    Start    End
# DDX11L1      1             11869    14409
# WASH7P       1             14404    29570
# ...

# Count genes
wc -l gene_meta_hg19.txt
# Should have 50,000-60,000 genes (exact number depends on GTF version)

# Check no "chr" prefix
grep "^[A-Z].*\tchr" gene_meta_hg19.txt
# Should return nothing (no matches)
```

---

## Alternative Sources

### 1. GENCODE (Recommended)

**Version 19** = hg19/GRCh37 (matches LDSC reference data)

```bash
# Comprehensive annotation
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz

# Basic gene annotation (smaller, faster)
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.basic.annotation.gtf.gz
```

### 2. UCSC Table Browser

1. Go to: https://genome.ucsc.edu/cgi-bin/hgTables
2. Select:
   - **Genome:** Human
   - **Assembly:** Feb. 2009 (GRCh37/hg19)
   - **Group:** Genes and Gene Predictions
   - **Track:** GENCODE V19 or RefSeq Genes
   - **Table:** knownGene
3. Output format: **GTF** or **selected fields from primary table**
4. Click "get output"

If using "selected fields":
- Select: name, chrom, txStart, txEnd
- Download and format as tab-separated

### 3. Ensembl BioMart

1. Go to: http://grch37.ensembl.org/biomart (Note: grch37 = hg19)
2. Choose Database: **Ensembl Genes 75**
3. Choose Dataset: **Human genes (GRCh37.p13)**
4. Attributes:
   - Gene stable ID
   - Gene name
   - Chromosome/scaffold name
   - Gene start (bp)
   - Gene end (bp)
5. Filters (optional):
   - Chromosome: 1,2,3,...,22,X,Y,MT
   - Gene type: protein_coding
6. Export as TSV

Then reformat with header: `Gene.name    Chromosome    Start    End`

---

## Common GTF Versions for hg19

| GTF Version | Description | Genes | Recommended |
|-------------|-------------|-------|-------------|
| GENCODE v19 | Comprehensive (matches 1000 Genomes) | ~60,000 | ✅ Yes |
| GENCODE v19 basic | Core transcripts only | ~50,000 | ✅ Yes |
| RefSeq (2013) | Conservative annotation | ~30,000 | ⚠️ Older |
| Ensembl 75 | Ensembl annotation | ~55,000 | ✅ Yes |

**Best choice:** GENCODE v19 - it's the reference used by 1000 Genomes Phase 3 and matches the LDSC baseline annotations.

---

## Troubleshooting

### Issue: "chr" prefix in chromosome names

If your GTF has "chr1" instead of "1":

```bash
# Fix with sed
sed 's/\tchr/\t/g' gene_meta_hg19.txt > gene_meta_hg19_fixed.txt
mv gene_meta_hg19_fixed.txt gene_meta_hg19.txt
```

Or the R script handles this automatically.

### Issue: Duplicate gene names

If you see duplicates:

```bash
# Check for duplicates
cut -f1 gene_meta_hg19.txt | sort | uniq -d

# The R script keeps only the first occurrence of each gene
```

### Issue: Wrong genome build (hg38 instead of hg19)

**CRITICAL:** LDSC reference files are hg19/GRCh37. Using hg38 coordinates will cause mismatches.

If you have hg38:
- **Option A:** Download hg19 GTF instead (recommended)
- **Option B:** Use liftOver tool to convert coordinates (complex, not recommended)

---

## Using the Gene Annotation File

After creating `gene_meta_hg19.txt`, update the path in your pipeline:

```bash
# Edit project_all/bedfiles/bed.R
# Line 1: Update to your file location
gene.anno.file <- "/full/path/to/gene_meta_hg19.txt"

# Or use relative path
gene.anno.file <- "../../enrichment_analysis/gene_meta_hg19.txt"
```

---

## File Size

Expected file size: ~3-5 MB (uncompressed, ~50,000 genes)

```bash
# Check file size
ls -lh gene_meta_hg19.txt

# Should be around 3-5 MB
```

If much smaller (< 1 MB), something went wrong with the conversion.

---

## Questions?

For more details on gene annotation sources, see:
- GENCODE: https://www.gencodegenes.org/human/release_19.html
- Ensembl GRCh37: http://grch37.ensembl.org
- UCSC hg19: https://genome.ucsc.edu/cgi-bin/hgGateway?db=hg19
