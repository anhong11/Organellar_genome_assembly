###Usage: sh trimmomatic.sh sample.name
### may need to edit this file to match different sample names, and the path to trimmomatic and adapter file.

while read line
do
  sbatch -n 8 --mem 64G -t 12:00:00 -p Lewis,BioCompute --wrap="java -jar /home/hongan/data/biosoft/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 8 -phred33 -trimlog '$line'.log '$line'_raw_R1.fastq.gz '$line'_raw_R2.fastq.gz '$line'.pair_R1.fastq.gz '$line'.unpair_1.fq.gz '$line'.pair_R2.fastq.gz '$line'.unpair_2.fq.gz ILLUMINACLIP:/home/hongan/data/biosoft/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36>'$line'.out"
done<$1
