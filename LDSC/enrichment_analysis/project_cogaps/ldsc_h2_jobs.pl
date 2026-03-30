use warnings;
use Cwd;

# change path below to your correct path
$ldsc = "/home/ubuntu/childrens_ldsc/src/ldsc/ldsc.py";
$baseline2 = "/home/ubuntu/childrens_ldsc/ref/baselineLD_v2.2_filtered/baselineLD.";
$weights = "/home/ubuntu/childrens_ldsc/ref/weights/weights.hm3_noMHC.";
$freq = "/home/ubuntu/childrens_ldsc/ref/plink_files_filtered/1000G.EUR.hg38.";

# Save the project directory before changing to gwas directory
$project_dir = "/home/ubuntu/childrens_ldsc/enrichment_analysis/project_cogaps";

open(OUT, ">$project_dir/ldsc_h2_jobs.txt");

opendir($dh, $project_dir);
#DB change regex to not exclude outpattern_2
#DB still to do: exclude readme.txt, trait_names_keys, sumstats_formatted_Description.xlsx
@outdirs = grep { !/^\./ && /^out_/ && !/_\d+_2$/ && -d "$project_dir/$_"} readdir($dh);
closedir $dh;

foreach $outdir (@outdirs){
	$outdir2 = $outdir."_2";
	mkdir "$project_dir/$outdir2";
}

# change path below to your correct path
chdir "/home/ubuntu/childrens_ldsc/ref/sumstats_formatted";
$cwd = cwd();
foreach $outdir (@outdirs){
	$outdir2 = $outdir."_2";
	foreach $gwas(<*.sumstats.gz>){

		$out = $gwas;
		$out =~ s/.gz$/.out/;
		print OUT "python $ldsc --h2 ${cwd}/$gwas ";
		print OUT "--w-ld-chr $weights ";
		print OUT "--ref-ld-chr ${project_dir}/${outdir}/chr.,$baseline2 ";
		print OUT "--overlap-annot ";
		print OUT "--frqfile-chr $freq ";
		print OUT "--out ${project_dir}/${outdir2}/$out ";
		print OUT "--print-coefficients\n";	
	}
}
close(OUT);
