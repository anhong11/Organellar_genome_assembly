while read line
do
  $fq_1=$fq."_raw_R1.fastq.gz"; # May need to modify here to adjust your own data
  $fq_2=$fq."_raw_R2.fastq.gz"; # May need to modify here to adjust your own data

  system (`sbatch -n 8 --mem 64G -t 12:00:00 -p Lewis,BioCompute --wrap="java -jar /home/hongan/data/biosoft/Trimmomatic-0.36/trimmomatic-0.36.jar PE -threads 8 -phred33 -trimlog $fq.log $fq_1 $fq_2 $fq.pair_R1.fastq.gz $fq.unpair_1.fq.gz $fq.pair_R2.fastq.gz $fq.unpair_2.fq.gz ILLUMINACLIP:/home/hongan/data/biosoft/Trimmomatic-0.36/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36>$fq.out"`);
 
}
