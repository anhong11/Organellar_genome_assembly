#!usr/bin/perl

##To get the matched annotated genes
#usage: perl ../get_matched_cpGene.pl ../Ath_cp_len.txt "$line"_ath.annot "$line"_ath_matched.annot mismatch_num

open LEN,"$ARGV[0]";
open ANN,"$ARGV[1]";
open OUT, ">$ARGV[2]";

my %hash;
while(<LEN>){
        chomp;
        my @array = split /\t/,$_;
        $hash{$array[0]}= $array[1];
}
my $mis = $ARGV[3];
my $last;
while(<ANN>){
        chomp;
        my @annot=split /\t/,$_;
        if($last ne $annot[0]){
                if (($annot[6]<(2+$mis)) and ($annot[7]>($hash{$annot[0]}-$mis+1))){
                        #my $ratio=($annot[7]-$annot[6]+1)/$hash{$annot[0]};
                        print OUT "$_\n";
                }
        }
        $last=$annot[0];
}
