# Organellar_genome_assembly
Based on a slurm HPC, may need to change the scripts to submit the job on different servers.
## 1. Identify chloroplast reads
### 1.1 Clean raw data with [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
```bash
sh trimmomatic.sh sample.name
```
### 1.2 Extract mapped paired-end clean reads
need [bwa](https://github.com/lh3/bwa), [samtools](https://github.com/samtools/samtools), and [bedtools](https://github.com/arq5x/bedtools2)
```bash
sbatch -n 8 --mem 64G -t 1:00:00 --wrap="bwa index ref_cp.fasta"
sh get_mapped_PEfq.sh sample.name ref_cp.fasta
```
### 1.3 Subsample mapped paired-end clean reads with [seqtk](https://github.com/lh3/seqtk) (optional)
```bash
sh get_subsample.sh sample.name 1000000
```
## 2. Extract common chloroplast genes
### 2.1 *De novo* assembly chloroplast genome with [Spades](https://github.com/ablab/spades)
```bash
sh run_spades.sh sample.name
```
### 2.2 Find common chloroplast genes
```bash
#get Ath chloroplast gene length
perl get_gene_len.pl Ath_cp_gene.fa Ath_cp_len.txt

#get matched annotated assembly genes for each sample
mkdir matched_annot
sh get_matched_annot.sh sample.name 
cd matched_annot
sh ../get_annot_num.sh ../sample.name > annotated_num.txt	#then decide if you need to discard some bad assembled samples
cat *.annot | awk '{print $1}' | sort | uniq -c | sort -nr > annot_ath_gene.stat	#only keep the genes annotated the same number with your sample number, then copy these gene names from annot_ath_gene.stat to "comm_ath_gene.name"

#
