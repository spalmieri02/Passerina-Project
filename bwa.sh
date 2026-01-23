#!/bin/bash

#SBATCH --job-name bwa
#SBATCH -A passerinagenome
#SBATCH -t 0-20:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=spalmie1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/mapping/error/err_BWA_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/mapping/out/std_BWA_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array=1-46    # EDIT BASED ON HOW MANY SAMPLES

# Load necessary modules - MAKE SURE THESE ARE THE CURRENT VERSIONS WITH MODULE SPIDER
module load gcc/14.2.0 bwa/0.7.17 samtools/1.20


# GO TO YOUR DIRECTORY OF TRIMMED FASTQ FILES
cd /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/trimming/trimmeddata/trim_fastq

# Define the path to your reference genome - LAZB
#  MAKE SURE YOU INDEXED IT BEFORE THIS SCRIPT OR MAPPING WILL FAIL!!
REF=/project/passerinagenome/mcarling/out/yahs/Pamoena_hap1/Pamoena.hic.hap1.p_ctg.clean_scaffolds_final.fa

# Make an output directoruy
OUTDIR=/cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/mapping/mappeddata
mkdir -p $OUTDIR

# Get a bash variable of all of the directories within the current directory
#    this works if you have one directory per sample, not if all samples are in a single directory
dirs=(*)

# Get a single sample, indexing by SLURM_ARRAY_TASK_ID
SAMPLE=${dirs[($SLURM_ARRAY_TASK_ID-1)]}


# move into sample directory
cd $SAMPLE

# Based on my specific sample name structure, get just the sample number from the file name


#run bwa
bwa mem -M -t $SLURM_CPUS_PER_TASK $REF *_R1_* *_R2_* | samtools view - -b | samtools sort - -o $OUTDIR/${SAMPLE}_sort.bam

# index the resulting bam file
samtools index -@ $SLURM_CPUS_PER_TASK $OUTDIR/${SAMPLE}_sort.bam
