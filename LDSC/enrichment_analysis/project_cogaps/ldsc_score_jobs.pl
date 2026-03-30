use warnings;

# change path below to your correct path
$ldsc="/home/ubuntu/childrens_ldsc/src/ldsc/ldsc.py";
$referenceDir="/home/ubuntu/childrens_ldsc/ref/plink_files_filtered/";
$hapmap3="/home/ubuntu/childrens_ldsc/ref/hapmap3_snps/";

open(OUT, ">ldsc_score_jobs.txt");

opendir($dh, "./");
@outdir = grep { !/^\./ && /^out_/ && -d "$_"} readdir($dh);
closedir $dh;

foreach $out (@outdir){
  foreach $i(1..22){
	$bfile=$referenceDir."1000G.EUR.hg38.".$i;
	$anno="./$out/chr.".$i.".annot.gz";
	$hapmapSNP=$hapmap3."hm.".$i.".snp";
	print OUT "python $ldsc --l2 --thin-annot --ld-wind-cm 1 ";
	print OUT "--bfile $bfile ";
	print OUT "--anno $anno ";
	print OUT "--out ./$out/chr.$i ";
	print OUT "--print-snps $hapmapSNP\n";
  }
}

close(OUT);
