#!/bin/bash

#SBATCH --job-name flagstat
#SBATCH -A passerinagenome
#SBATCH -t 0-36:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=14
#SBATCH --mem=40G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=spalmie1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/checkmapping/error/err_flagstat_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/checkmapping/out/std_flagstat_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array 1-46    # EDIT BASED ON HOW MANY SAMPLES



# load modules necessary - check that these are current versions
module load gcc/14.2.0 samtools/1.20


# Set the path to your reference genome
REF=/project/passerinagenome/mcarling/out/yahs/Pamoena_hap1/Pamoena.hic.hap1.p_ctg.clean_scaffolds_final.fa

# Set up an output directory and create it
OUTDIR=/cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/checkmapping/flagstat_report
mkdir -p $OUTDIR


# Set working directory to where the sorted reads are

cd /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/mapping/mappeddata
#array of files

bams=(*.bam)

SAMPLE=${bams[($SLURM_ARRAY_TASK_ID-1)]}


#run
samtools flagstat -@ $SLURM_CPUS_PER_TASK $SAMPLE > $OUTDIR/${SAMPLE}_flagstat.out
