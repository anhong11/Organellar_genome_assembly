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

#get concatnated and co sequences
sbatch -n 8 --mem 64G -t 1:00:00 -p Lewis,BioCompute --wrap="sh get_comm_genes.sh sample.name"
sbatch -n 8 --mem 64G -t 1:00:00 -p Lewis,BioCompute --wrap="perl get_ath_ref_fa.pl Ath_cp_gene.fa comm_ath_gene.name"
mv ath_co* all_matched_uniq_seq; cd all_matched_uniq_seq
ls *comGene.fa > comGene_fa.name
sbatch -n 8 --mem 64G -t 1:00:00 -p Lewis,BioCompute --wrap="perl ../get_singleGene.pl ../comm_ath_gene.name comGene_fa.name"
```
## 3. Make concatenate phylogeny
### 3.1 Align each gene with [Mafft](https://mafft.cbrc.jp/alignment/software/), and clean and concatenate sequence with [Phyutility](https://github.com/blackrim/phyutility)
```bash
sbatch -n 8 --mem 64G -t 1:00:00 -p Lewis,BioCompute --wrap="sh ../mafft.sh ../comm_ath_gene.name"
sbatch -n 8 --mem 64G -t 2:00:00 -p Lewis,BioCompute --wrap="sh phyutility_clean.sh ../comm_ath_gene.name"
sbatch -n 8 --mem 64G -t 2:00:00 --wrap="phyutility -concat -out ./conc_cln-aln.nexus -in ./ATCG00010.1.cln-aln ./ATCG00020.1.cln-aln ./ATCG00030.1.cln-aln ./ATCG00040.1.cln-aln ./ATCG00060.1.cln-aln ./ATCG00065.1.cln-aln ./ATCG00080.1.cln-aln ./ATCG00090.1.cln-aln ./ATCG00100.1.cln-aln ./ATCG00110.1.cln-aln ./ATCG00120.1.cln-aln ./ATCG00140.1.cln-aln ./ATCG00150.1.cln-aln ./ATCG00160.1.cln-aln ./ATCG00180.1.cln-aln ./ATCG00200.1.cln-aln ./ATCG00210.1.cln-aln ./ATCG00220.1.cln-aln ./ATCG00230.1.cln-aln ./ATCG00240.1.cln-aln ./ATCG00250.1.cln-aln ./ATCG00260.1.cln-aln ./ATCG00270.1.cln-aln ./ATCG00280.1.cln-aln ./ATCG00290.1.cln-aln ./ATCG00300.1.cln-aln ./ATCG00310.1.cln-aln ./ATCG00320.1.cln-aln ./ATCG00330.1.cln-aln ./ATCG00340.1.cln-aln ./ATCG00360.1.cln-aln ./ATCG00370.1.cln-aln ./ATCG00380.1.cln-aln ./ATCG00390.1.cln-aln ./ATCG00410.1.cln-aln ./ATCG00420.1.cln-aln ./ATCG00430.1.cln-aln ./ATCG00440.1.cln-aln ./ATCG00450.1.cln-aln ./ATCG00460.1.cln-aln ./ATCG00470.1.cln-aln ./ATCG00480.1.cln-aln ./ATCG00510.1.cln-aln ./ATCG00530.1.cln-aln ./ATCG00540.1.cln-aln ./ATCG00550.1.cln-aln ./ATCG00560.1.cln-aln ./ATCG00570.1.cln-aln ./ATCG00580.1.cln-aln ./ATCG00590.1.cln-aln ./ATCG00610.1.cln-aln ./ATCG00620.1.cln-aln ./ATCG00630.1.cln-aln ./ATCG00640.1.cln-aln ./ATCG00650.1.cln-aln ./ATCG00680.1.cln-aln ./ATCG00690.1.cln-aln ./ATCG00700.1.cln-aln ./ATCG00710.1.cln-aln ./ATCG00720.1.cln-aln ./ATCG00730.1.cln-aln ./ATCG00750.1.cln-aln ./ATCG00760.1.cln-aln ./ATCG00770.1.cln-aln ./ATCG00780.1.cln-aln ./ATCG00790.1.cln-aln ./ATCG00810.1.cln-aln ./ATCG00830.1.cln-aln ./ATCG00840.1.cln-aln ./ATCG00850.1.cln-aln ./ATCG00880.1.cln-aln ./ATCG00890.1.cln-aln ./ATCG00900.1.cln-aln ./ATCG00905.1.cln-aln ./ATCG00910.1.cln-aln ./ATCG00920.1.cln-aln ./ATCG00940.1.cln-aln ./ATCG00950.1.cln-aln ./ATCG00960.1.cln-aln ./ATCG00970.1.cln-aln ./ATCG00980.1.cln-aln ./ATCG00990.1.cln-aln ./ATCG01020.1.cln-aln ./ATCG01030.1.cln-aln ./ATCG01040.1.cln-aln ./ATCG01050.1.cln-aln ./ATCG01080.1.cln-aln ./ATCG01100.1.cln-aln ./ATCG01110.1.cln-aln ./ATCG01120.1.cln-aln ./ATCG01140.1.cln-aln ./ATCG01150.1.cln-aln ./ATCG01160.1.cln-aln ./ATCG01170.1.cln-aln ./ATCG01180.1.cln-aln ./ATCG01190.1.cln-aln ./ATCG01210.1.cln-aln ./ATCG01220.1.cln-aln ./ATCG01230.1.cln-aln ./ATCG01240.1.cln-aln ./ATCG01250.1.cln-aln ./ATCG01260.1.cln-aln ./ATCG01290.1.cln-aln ./ATCG01300.1.cln-aln ./ATCG01310.1.cln-aln"
```
### 3.2 Make concatenate phylogeny with [RAxML](https://cme.h-its.org/exelixis/web/software/raxml/index.html)
```bash
perl refmt_nexus.pl conc_cln-aln.nexus conc_cln-aln.model conc_cln-aln.phylip
sbatch -n 24 --mem 200G -t 2-00:00 -p BioCompute --wrap="raxml -f a -x 12345 -p 12345 -# 100 -m GTRGAMMA -s conc_cln-aln.phylip -q conc_cln-aln.model -n conc_cln-aln -T 24"
```








