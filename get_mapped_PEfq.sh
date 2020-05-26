##Usage: sh get_mapped_PEfq.sh sample.name bwa_indexed_reference

while read line
do
	sbatch -n 14 --mem 128G -t 1-00:00 -p Lewis,BioCompute --wrap="bwa mem -t 14 $2 '$line'.pair_R1.fastq.gz '$line'.pair_R2.fastq.gz | samtools sort -@ 14 -m 8G -o '$line'_sort.bam -; \
	samtools index '$line'_sort.bam; \
	samtools view -b -F 4 '$line'_sort.bam > '$line'_sort_map.bam; \
	samtools sort -@ 14 -m 8G -n '$line'_sort_map.bam > '$line'_sort_map_sort.bam; \
	bedtools bamtofastq -i '$line'_sort_map_sort.bam -fq '$line'_mapPair_R1.fq -fq2 '$line'_mapPair_R2.fq; \
	rm '$line'*bam*"
done <$1
