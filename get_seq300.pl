#!usr/bin/perl

###To get the scaffolds longer than 300bp
##Usage: perl get_seq300.pl input.fa output.fa

open OUT, ">$ARGV[1]";

use Bio::SeqIO;
my $in = Bio::SeqIO->new(-file => "$ARGV[0]" ,-format => 'fasta');

while(my $obj=$in->next_seq()){
	my $id =$obj->id;
	my $len = $obj->length;
	my $seq = $obj->seq;
	if ($len>300){
		print OUT ">$id\n$seq\n";
	}
}

system(`grep -c '>' $ARGV[1]`);
