###Usage: sh run_spades.sh sample.name

while read line
do
        sbatch -n 8 --mem 64G -t 8:00:00 -p Lewis,BioCompute --wrap="spades.py --careful -o '$line'_spades -1 '$line'_mapPair_sub_R1.fq -2 '$line'_mapPair_sub_R2.fq -t 8"
done<$1
