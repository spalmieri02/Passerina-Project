#!/bin/bash

#SBATCH --job-name vcf_filter
#SBATCH -A passerinagenome
#SBATCH -t 0-12:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=spalmie1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/postvariantfiltering/error/err_filt_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/postvariantfiltering/out/std_filt_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)


#load packages - check that these are current
module load gcc/14.2.0 bcftools/1.20 vcftools/0.1.17

#go to directory- CHANGE TO SORTED VCFs?
cd /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/sortedvcfs/combined_sorted_vcf

# set up the inputs --> what to put here?
VCF_IN=genome.vcf.gz
VCF_OUT=filtered_genome.vcf.gz


# Set up filters as bash variables to be called in the vcftools command
MAF=0.01
MISS=0.7
QUAL=30
MIN_DEPTH=7
MIN_ALLELES=2
MAX_ALLELES=2


# Apply those filters in vcftools
vcftools --gzvcf $VCF_IN \
	--remove-indels \
	--maf $MAF \
	--max-missing $MISS \
	--minQ $QUAL \
	--minDP $MIN_DEPTH \
	--min-alleles $MIN_ALLELES \
	--max-alleles $MAX_ALLELES \
	--recode --stdout | gzip -c > $VCF_OUT
