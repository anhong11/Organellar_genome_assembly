###Usage: sh get_subsample.sh sample.name subsample_number

while read line
do
        seed=${line:2:3} #may need to change to fit different sample names. Here means extract the second to forth characters (first one is 0)
        sbatch -n 12 --mem 96G -t 4:00:00 -p Lewis,BioCompute --wrap="seqtk sample -s $seed '$line'_mapPair_R1.fq $2 > '$line'_mapPair_sub_R1.fq; \
        seqtk sample -s $seed '$line'_mapPair_R2.fq $2 > '$line'_mapPair_sub_R2.fq; \
        gzip '$line'_mapPair_R*fq"

done<$1
