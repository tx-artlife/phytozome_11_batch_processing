#!/usr/bin/perl;
use strict;
##this perl add the taxon name to gene name in fasta file for each species using the orthomcl perl code orthomclAdjustFasta
##for example: >AT3G02220 will be modified as >Ath|AT3G02220

##output files will be in the same folder as this perl, so make sure run this perl in a specific folder 
my $processed="/home/xutan/plantae_genome_phytozome11/processed/processed/";##output folder of batch.pl
my $splist="/home/xutan/plantae_genome_phytozome11/processed/species_list_shortname.txt"; ##
my $orthomclAdjustFasta="/home/xutan/plantae_genome_phytozome11/processed/orthomclAdjustFasta";##perl code from orthomcl


open(IN,$splist) or die "$splist not found\n";
while(<IN>){
	my @a=split/\s+/,$_;
	my $shortnm=$a[1];
	
	my $fasta=$processed.$shortnm."/".$shortnm."\.fasta";
	if(!-e $fasta){
		print "cannot find $fasta\n";
		exit 0;
	}
	
	print "run orthomclAdjustFasta for $shortnm...\n";
	`perl $orthomclAdjustFasta $shortnm $fasta 1`;
}

close IN;
