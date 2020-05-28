#!usr/bin/perl

##To get the scaffolds longer than 300bp
#Usage: perl get_seq_len.pl input.fa output.txt

use Bio::SeqIO;

open OUT, ">$ARGV[1]";
my $in = Bio::SeqIO->new(-file => "$ARGV[0]" ,-format => 'fasta');

while(my $obj=$in->next_seq()){
	my $id =$obj->id;
	my $len = $obj->length;
	print OUT "$id\t$len\n";
}
