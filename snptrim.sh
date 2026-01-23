#!/bin/bash

#SBATCH --job-name=snpfastp
#SBATCH -A passerinagenome
#SBATCH -t 0-16:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16  
#SBATCH --mem=20G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=spalmie1@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/trimming/error/err_trim_%A_%a.err   # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/trimming/out/std_trim_%A_%a.out   # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array=1-46     # EDIT BASED ON HOW MANY SAMPLES

# Load fastp module
module load fastp/0.23.4

# Define paths   - EDIT TO YOUR PATHS
RAW_DIR="/cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/snprawdata"
OUTDIR="/cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/trimming/trimmeddata/trim_fastq"
REPORTDIR="/cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/trimming/reports/fastp_reports"


# Ensure output directories exist
mkdir -p "$OUTDIR" "$REPORTDIR"

# Get all subdirectories (samples) - here each pair of reads is in a separate sample directory
cd "$RAW_DIR"
dirs=(*/)

# Change into a single sample directory using SLURM_ARRAY_TASK_ID to index
sample_dir="${dirs[$SLURM_ARRAY_TASK_ID-1]}"
sample="${sample_dir%/}"
cd "$sample"

# Extract sample name (remove trailing slash and use as ID) - this depends on exactly how your files are named


# Define input and output files - this assumes that there are ONLY 1 R1 and 1 R2 in the current directory
FORWARD=$(ls *_1.fq.gz)
REVERSE=$(ls *_2.fq.gz)

# Define an output directory for this specific sample
OUT_SAMPLE="${OUTDIR}/trim_read_${sample}"
mkdir -p "$OUT_SAMPLE" # make the directory

# Make names for the output files
O_FOR="${OUT_SAMPLE}/${sample}_R1_trimmed.fastq.gz"
O_REV="${OUT_SAMPLE}/${sample}_R2_trimmed.fastq.gz"
REPORT_JSON="${REPORTDIR}/${sample}_fastp.json"
REPORT_HTML="${REPORTDIR}/${sample}_fastp.html"

# Run fastp
fastp -i "$FORWARD" -I "$REVERSE" \
      -o "$O_FOR" -O "$O_REV" \
      -h "$REPORT_HTML" -j "$REPORT_JSON" \
      --length_required 70 \
      --detect_adapter_for_pe \
      --correction \
      --trim_poly_g --trim_poly_x \
      --qualified_quality_phred 20 \
      --unqualified_percent_limit 30 \
      --n_base_limit 5 \
      --cut_window_size 4 --cut_mean_quality 20 --cut_right \
      -w "$SLURM_CPUS_PER_TASK"
