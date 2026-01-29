#!/bin/bash

#SBATCH --job-name vcf_thin
#SBATCH -A passerinagenome
#SBATCH -t 0-10:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=spalmie1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/thinning/error/err_filt_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/thinning/out/std_filt_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)


#load packages - check that these are current
module load gcc/14.2.0 bcftools/1.20 vcftools/0.1.17 htslib/1.20 

#go to directory
cd /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/finalvcf/finalfiltered_vcf

# set up the inputs & output directory & output file name:
VCF_IN=filtered_genome.vcf.gz
OUT_DIR=/cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/thinning
VCF_OUT=thinned_genome.vcf.gz


# thinning w/distance of 100k alleles
THIN_DIST=100000


# Apply those filters in vcftools
vcftools --gzvcf $VCF_IN \
	--thin $THIN_DIST \
	--recode --stdout | bgzip -c > $OUT_DIR/$VCF_OUT
