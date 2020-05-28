#!usr/bin/perl

##Usage: perl get_singleGene.pl uniq_gene.name fasta.name

use Bio::SeqIO;

open IN, "$ARGV[0]";

while (<IN>){
	chomp;
	my $gene=$_;
	my $output="$gene".".fa";
	open OUT, ">$output";
	open SEQ, "$ARGV[1]";
	while (<SEQ>){
		chomp;
		my $sample=$_;
		my $sampleNum=$sample;
		$sampleNum =~ s/_comGene\.fa//g;
		#print $sampleNum;
		my $in = Bio::SeqIO->new(-file => "./$sample" ,-format => 'fasta');
		my %hash;
		while(my $obj=$in->next_seq()){
			my $id =$obj->id;
			$id =~ s/^.*_//g;
			my $seq = $obj->seq;
			$hash{$id}=$seq;
		}
		print OUT ">$sampleNum"."_$gene\n$hash{$gene}\n";
		print "$gene $sampleNum done!"
	}
	close SEQ;
	close OUT;
	print "---------------$gene done! -----------------";
}
