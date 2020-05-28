###Usage: sh get_comm_genes.sh sample.name

mkdir all_matched_uniq_seq
while read line
do
	cd "$line"_spades
	perl ../get_comm_seq.pl ../comm_ath_gene.name $line scaffolds_300.fa 
	mv "$line"_co*.fa ../all_matched_uniq_seq
	cd ../
done<$1
