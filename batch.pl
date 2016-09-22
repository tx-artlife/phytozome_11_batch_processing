#!usr/bin/perl;
use warnings;

##this perl process the downloaded gff3 and protein.fasta file for all species from phytozome11.0
##usage:
	#1,download gff3 file and protein.fasta file for all species (a zip file)
	#2,extract the zip file into a folder
	#3,set up $dir as the above folder pathway and generate species list file with shortnames
		#species_fullname	species_shortname
	#4 run code: perl this
	#5 output
		#1. gff3.gene.name.txt
		#2. fasta.gene.name.txt

$raw_dir="/home/xutan/plantae_genome_phytozome11/PhytozomeV11_rawdata/";
$splist="species_list_shortname.txt";
$out_dir="/home/xutan/plantae_genome_phytozome11/processed/processed/";
#$splist="test.sp.txt";

##perl code
$parse_gff_perl="/home/xutan/plantae_genome_phytozome11/processed/parse.gff3.pl";
$parse_fasta_perl="/home/xutan/plantae_genome_phytozome11/processed/parse.fasta.pl";


##read in species list and shortnames;
open(IN,$splist) or die "no $splist found\n";
%species=();

while(<IN>){
	$line=$_;
	chomp($line);
	@a=split/\s+/,$line;
	$species{$a[0]}=$a[1];
}
close IN;

##unzip gz files and rename them using the shortname for each species
`rm gff3.gene.name.txt`;
`rm fasta.gene.name.txt`;

foreach $key(keys %species){
	$sp_dir=$raw_dir.$key."/annotation/";
	print "working in $sp_dir for $key ...\n";
	##remove existing gff3 and fasta files
	`rm $sp_dir*.gff3`;
        `rm $sp_dir*.protein.fasta`;
	##run command gzip -dk (keep the gz file)
	`gzip -dk $sp_dir*.gz`;
	##rename file using species short name
	`mv $sp_dir*.gff3 $sp_dir$species{$key}.gff3`;
	`mv $sp_dir*.protein.fa $sp_dir$species{$key}.protein.fasta`;
	##retrive gene name formation from gff3 and fasta file
	`grep "gene" $sp_dir$species{$key}.gff3 |cut -f9|head -1 >>gff3.gene.name.txt`;
	`grep ">" $sp_dir$species{$key}.protein.fasta |head -1 >>fasta.gene.name.txt`;
}
print "====================unzipping files is done!===============================\n";
print "\nstart parsing gff3 files\n";
	
##parse gff3 and fasta files
if(!-e $parse_gff_perl | !-e $parse_fasta_perl){
	print $parse_gff_perl," or ",$parse_fasta_perl," is not found\n";
	exit 0;
}

foreach $key(keys %species){
	print "parsing gff3 and fasta files for $key...\n"; 
	$sp_dir=$out_dir.$species{$key}."/";

	##create folder or clear files	
	if(!-e $sp_dir){
		print "create folder: $sp_dir for species $key\n";
		`mkdir $sp_dir`;
	}else{
		print "$sp_dir exists, clearing it...\n";
		`rm $sp_dir*`;
	}

	##parse gff3
	print "parsing gff3 file...\n";
	$gff3_file=$raw_dir.$key."/annotation/".$species{$key}.".gff3";
	$parsed_gff_file=$sp_dir.$species{$key}.".gff";

	`perl $parse_gff_perl $gff3_file $parsed_gff_file >>log.txt`;
	
	##parse fasta
	print "parsing fasta file...\n";
	$raw_fasta_file=$raw_dir.$key."/annotation/".$species{$key}.".protein.fasta";
	$parsed_fasta_file=$sp_dir.$species{$key}.".fasta";	
	
	`perl $parse_fasta_perl $raw_fasta_file $parsed_fasta_file $parsed_gff_file >>log.txt`;
}





