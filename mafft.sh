##Usage: sh mafft.sh comm_ath_gene.name

while read line
do
        mafft "$line".fa > "$line".aln
        sed -i 's/_AT.*//g' "$line".aln
        echo $line done.
done<$1
