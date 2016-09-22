# phytozome_11_batch_processing
process downloaded phytozome 11.0 protein fasta file and gff3 file in batch

Input: 
  1. batch download protein fasta and gff3 file for multiple species on Phytozome 11 to a single zip file
  2. unzip the file will generate a folder:
      ------sp1/annotation/sp1.protein.fa.gz;sp1.gene.gff3.gz
        |
        |---sp2/annotation/sp2.protein.fa.gz;sp2.gene.gff3.gz
        |
        ----sp3...
  3. create a txt file which contains the short name for each species
        sp1       sp1_shortname
        sp2       sp2_shortname
  4. a folder to contain the processed files: output_folder
        ... ...

Output: 
  0. for each species, create a folder in output folder using the shortnames
  1. extract gff3 file to sp_shortname.gff3 and protein fasta file to sp_shortname.protein.fasta into the same folder as gz files for each species
  2. process gff3 file for each gene by using XXXXXX of 'Name=XXXXXX' part as gene name to generate a gff file in the output_folder/sp/:
      chrom start end XXXXXX(gene)
  3. for each gene, find the longest transcript in protein fasta file and output them in a fasta file in output_folder/sp/;

Code:
  batch.pl
  
