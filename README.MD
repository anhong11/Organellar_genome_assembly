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
### 2.1 De novo assembly chloroplast genome with [Spades](https://github.com/ablab/spades)
```bash
sh run_spades.sh sample.name
```
