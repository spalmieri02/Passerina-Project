#!/bin/bash

#SBATCH --job-name combinevcfs
#SBATCH -A passerinagenome
#SBATCH -t 0-20:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=spalmie1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/combinesortedvcfs/error/err_combinevcfs_%A.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/combinesortedvcfs/out/std_combinevcfs_%A.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)


#load packages - check these are up to date
module load gcc/14.2.0 bcftools/1.20

#move to directory with all your vcf files 
cd /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/sortedvcfs/vcfs_sorted

#paths based on what you named your files
TOCOMBINE=sort_*.vcf.gz
COMBINED=genome.vcf.gz


# combine
bcftools concat -Oz -o $COMBINED $TOCOMBINE
