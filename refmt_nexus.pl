#!usr/bin/perl

##Usage: perl refmt_nexus.pl input.nexus output.model output.phylip

unless ($#ARGV eq 2){
	print "Usage: perl refmt_nexus.pl input.nexus output.model output.phylip\n";
	exit;
}

open IN, "$ARGV[0]";
open MD, ">$ARGV[1]";
open PHY, ">$ARGV[2]";

my ($sample, $snp);
while(<IN>){
    chomp;
	if (/^\t\[/){
        $_=~ s/\t\[//g;
        $_=~ s/ \]//g;
        $_=~ s/ AT/\nDNA,AT/g;
        $_=~ s/^AT/DNA,AT/g;
        $_=~ s/ /=/g;
        print MD "$_";
        next;
    }
	if (/DIMENSIONS/){
		$sample=$_;
		$sample=~ s/\tDIMENSIONS NTAX=//;
		$sample=~ s/ NC.*//g;
		$snp=$_;
		$snp=~ s/\tDIMEN.*NCHAR=//g;
		$snp=~ s/;//;
		print PHY " $sample $snp\n";
		next;
	}
	if(/DATATYPE/){
		next;
	}
	if(/MATRIX/){
		next;
	}
	if(/^\t/){
		$_=~ s/^\t//;
		$_=~ s/\t/ /g;
		print PHY "$_\n";
	}
}
