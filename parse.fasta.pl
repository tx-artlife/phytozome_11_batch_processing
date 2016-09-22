#!usr/bin/perl;
use warnings;
use Bio::SeqIO;

if($#ARGV!=2){
	print "usage: perl this raw_fasta_file out_fasta_file gff_file\n";
	exit 0;
}

$raw_fasta=$ARGV[0];
$out_fasta=$ARGV[1];
$gff=$ARGV[2];

##read in gff file to get all genes in gff
%gff_genes=();
open(IN,$gff) or die "no $gff found\n";
while(<IN>){
	$line=$_;
	chomp($line);
	@a=split/\s+/,$line;
	$gff_genes{$a[3]}=0;
}
close IN;

##parse raw fasta file
$seqio=Bio::SeqIO->new (-file=>$raw_fasta);

%genes=();
while($seqObj=$seqio->next_seq){
        $seq=$seqObj->seq;
        $name=$seqObj->desc;##descriptions of transcript, not including gene id(first column)
        #print $name,"\n";
        
	@array=split/\s+/,$name;
        $locus=$array[2];##locus=XXXXXX
        $locus=~/locus=(.+)/;
        $gene=$1;

	if(defined $gff_genes{$gene}){
		$gff_genes{$gene}++;
	}else{
		print "gene $gene not found in gff file\n";
	}


        if(!defined $genes{$gene}){
                $genes{$gene}=$seq;
        }else{
                if(length($genes{$gene})<length($seq)){
                        $genes{$gene}=$seq;
                }
        }



}

##check genes with mutilple transcript
foreach $key(keys %gff_genes){
	if($gff_genes{$key}>1){
		#print $key,"\t",$gff_genes{$key},"\n";
	}
}

##output longest sequence for each gene;
$output="";
foreach $key(keys %genes){
	$output=$output.">$key\n$genes{$key}\n";
}

open(OUT,">$out_fasta") and print OUT $output;
close OUT;

