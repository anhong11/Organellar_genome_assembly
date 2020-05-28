#!usr/bin/perl
##Usage:perl get_comm_seq.pl comm_ath.name sample_num(like D1020) blastdb_name

open ATH, "$ARGV[0]";
open ANN, "$ARGV[1]"."_ath_matched.annot";
open OUT1, ">$ARGV[1]"."_comGene.fa";
open OUT2, ">$ARGV[1]"."_conj.fa";

my %hash;
while (<ATH>){
	chomp;
	$hash{$_}=$_;
}

print OUT2 ">$ARGV[1]_conj\n";

while(<ANN>){
	chomp;
	my @array= split /\t/,$_;
	if(exists $hash{$array[0]}){
		my $max;
                my $min;
                my $strand;
		if ($array[8]>$array[9]){
			$max=$array[8];
			$min=$array[9];
			$strand="minus";
		}else{
			$max=$array[9];
			$min=$array[8];
			$strand="plus";
		}
		my $seq = readpipe("blastdbcmd -db $ARGV[2] -entry $array[1] -range $min-$max -outfmt %s -strand $strand");
		chomp ($seq);
		my $name = "$ARGV[1]"."_$array[0]";
		print OUT1 ">$name\n$seq\n";
		print OUT2 "$seq";
	}
}
print OUT2 "\n";
