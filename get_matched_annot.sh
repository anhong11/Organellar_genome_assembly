###Usage: sh get_matched_annot.sh sample.name

while read line
do
        sbatch -n 8 --mem 64G -t 2:00:00 --wrap="cd '$line'_spades; \
        perl ../get_seq300.pl scaffolds.fasta scaffolds_300.fa; \
        makeblastdb -in scaffolds_300.fa -dbtype nucl -hash_index -parse_seqids; \
        blastn -query ../Ath_cp_gene.fa -db scaffolds_300.fa -evalue 1E-5 -outfmt 6 -num_threads 12 -out '$line'_ath.annot; \
        perl ../get_matched_cpGene.pl ../Ath_cp_len.txt '$line'_ath.annot '$line'_ath_matched.annot 2; \
        cp '$line'_ath_matched.annot ../matched_annot; \
        cd ../"
done<$1
