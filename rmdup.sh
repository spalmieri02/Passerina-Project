#!/bin/bash

#SBATCH --job-name rmd
#SBATCH -A passerinagenome
#SBATCH -t 0-72:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=spalmie1@uwyo.edu        # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/mapping/removeduplicates/error/err_rmd_%A_%a.err    # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/mapping/removeduplicates/out/std_rmd_%A_%a.out    # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array 1-46          # EDIT BASED ON HOW MANY SAMPLES


# Load modules - make sure these are current
module load gcc/14.2.0 picard/3.2.0 samtools/1.20

# Set up output directory variable - set this to where you want to output to go
OUTDIR=/cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/mapping/removeduplicates/removed
mkdir -p $OUTDIR  # make the directory if it doens't exist

# Set working dir to where the bam files are - set to your location
cd /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/mapping/mappeddata

#array of files - this takes all the bam file names from the current directory and puts them into a bash array (analagous to an R vector if you are more familiar with R)
bams=(*.bam)

# Get the file name of the single sample to work on in a given array job
SAMPLE=${bams[($SLURM_ARRAY_TASK_ID-1)]}

# get individual name only from that file name - this works with my file name structure, may not for you



#add readgroups - this is necessary if you don't have readgroups already assigned to your files
picard AddOrReplaceReadGroups \
    -I $SAMPLE \
    -O $OUTDIR/${SAMPLE}.rg.bam \
    -RGID id \
    -RGLB lib1 \
    -RGPL illumina \
    -RGPU unit1 \
    -RGSM $SAMPLE
 
#run picard MarkDuplicates
picard \
 MarkDuplicates -REMOVE_DUPLICATES true \
 -ASSUME_SORTED true -VALIDATION_STRINGENCY SILENT \
 -INPUT $OUTDIR/${SAMPLE}.rg.bam \
 -OUTPUT $OUTDIR/${SAMPLE}.rmd.bam \
 -METRICS_FILE $OUTDIR/${SAMPLE}.rmd.bam.metrics
 
# Index the new bam file with duplicates removed
samtools index $OUTDIR/${SAMPLE}.rmd.bam
