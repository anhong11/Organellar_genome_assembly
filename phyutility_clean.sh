
###Usage: sh phyutility_clean.sh gene.name

while read line
do
        phyutility -clean 0.5 -in "$line".aln -out "$line".cln-aln
done<$1
