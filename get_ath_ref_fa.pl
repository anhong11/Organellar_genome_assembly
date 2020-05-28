#!usr/bin/perl

##To get the ath_comGene.fa and ath_conj.fa
##Usage: perl get_ath_ref_fa.pl Ath_cp_gene.fa comm_ath_gene.name



open IN, "$ARGV[1]";
open OUT, ">ath_comGene.fa";
open OUT2, ">ath_conj.fa";

use Bio::SeqIO;
my $in = Bio::SeqIO->new(-file => "$ARGV[0]" ,-format => 'fasta');
my %hash;

while(my $obj=$in->next_seq()){
        my $id =$obj->id;
        my $seq = $obj->seq;
        $hash{$id}=$seq;
}

print OUT2 ">Ath_conj\n";
while(<IN>){
        chomp;
        print OUT ">Ath_$_\n$hash{$_}\n";
        print OUT2 "$hash{$_}";
}
print OUT2 "\n";
