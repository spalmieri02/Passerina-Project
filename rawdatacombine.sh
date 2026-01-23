#!/bin/bash

#SBATCH --job-name rawdatacombine
#SBATCH -A passerinagenome  ## EDIT TO YOUR PROJECT
#SBATCH -t 0-05:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=spalmie1@uwyo.edu   # EDIT TO YOUR EMAIL
#SBATCH -e  /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/combineerror/err_fastqc_%A_%a.err 
#SBATCH -o  /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/combineout/std_fastqc_%A_%a.out  


cd /cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/snprawdata

ARCHIVE_ROOT="/cluster/medbow/project/passerinagenome/genome_data/wgs/novo_jan2026/00.snpdata/snprawdatacombine"
mkdir -p "$ARCHIVE_ROOT"

for SAMPLE in B*; do
    [ -d "$SAMPLE" ] || continue

    R1_FILES=("$SAMPLE"/*_1.fq.gz)
    R2_FILES=("$SAMPLE"/*_2.fq.gz)

    # Skip if no FASTQs
    if [ ! -e "${R1_FILES[0]}" ]; then
        continue
    fi

    # Sanity check
    if [ "${#R1_FILES[@]}" -ne "${#R2_FILES[@]}" ]; then
        echo "ERROR: unequal R1/R2 in $SAMPLE" >&2
        exit 1
    fi

    # Only act on multi-run samples
    if [ "${#R1_FILES[@]}" -gt 1 ]; then
        echo "Processing multi-run sample $SAMPLE"

        ARCHIVE_DIR="$ARCHIVE_ROOT/$SAMPLE"
        mkdir -p "$ARCHIVE_DIR"

        # Move original FASTQs (and MD5s if present)
        mv "$SAMPLE"/*.fq.gz "$ARCHIVE_DIR"/
        [ -e "$SAMPLE/MD5.txt" ] && mv "$SAMPLE/MD5.txt" "$ARCHIVE_DIR"/

        # Concatenate
        cat "$ARCHIVE_DIR"/*_1.fq.gz > "$SAMPLE/${SAMPLE}_1.fq.gz"
        cat "$ARCHIVE_DIR"/*_2.fq.gz > "$SAMPLE/${SAMPLE}_2.fq.gz"
    fi
done
