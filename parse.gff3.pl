#!usr/bin/perl;
use warnings;

if($#ARGV!=1) {###check if take in two parameters
	print "usage: perl this raw_gff3_file parsed_gff_file\n";
	exit 0;
}
$gff3=$ARGV[0];
$gff=$ARGV[1];

$output="";
%genes=();#check uniqueness of genes , for debugging
open(IN,$gff3) or die "no $gff3 found\n";
while(<IN>){
	$line=$_;
	if($line=~/#/){next;};
	chomp($line);
	@a=split/\s+/,$line;
	if($a[2] eq "gene"){
		$chrom=$a[0];
		$start=$a[3];
		$end=$a[4];
		$a[8]=~/Name=([^;]+)/;
		$gene=$1;
		if(defined $genes{$gene}){
			print $gene,"\tfound again\n";
		}else{
			$genes{$gene}=1;
		}
		$output=$output.$chrom."\t".$start."\t".$end."\t".$gene."\n";
	}
}

close IN;

open(OUT,">$gff") and print OUT $output;
close OUT;


