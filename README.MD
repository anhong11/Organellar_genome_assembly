# Organellar_genome_assembly
Based on a slurm HPC, may need to change the scripts to submit the job on different servers.
## 1. Identify chloroplast reads
### 1.1 Clean raw data with Trimmomatic
```bash
perl trimmomatic.pl sample.name
```
### 1.2 Extract mapped paired-end clean reads
```bash
sbatch -n 8 --mem 64G -t 1:00:00 --wrap="bwa index ref_cp.fasta"
sh get_mapped_PEfq.sh sample.name ref_cp.fasta
```
