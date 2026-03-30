use warnings;
use File::Basename;

# change path below to your correct path
$make_annot="/home/ubuntu/childrens_ldsc/src/ldsc/make_annot.py";
$referenceDir="/home/ubuntu/childrens_ldsc/ref/plink_files_filtered/";


open(OUT, ">ldsc_anno_jobs.txt");
foreach $bedfile (<bedfiles/*.bed>){
	$out = basename($bedfile);
	$out =~ s/\.bed//;
	$outdir="out_".$out;
	mkdir $outdir;
	foreach $i(1..22){
		$bimfile=$referenceDir."1000G.EUR.hg38.".$i.".bim";
		print OUT "python $make_annot ";
		print OUT "--bed-file $bedfile ";
		print OUT "--bimfile $bimfile ";
		print OUT "--annot-file ./${outdir}/chr.${i}.annot.gz\n";
	}
}
close(OUT);
