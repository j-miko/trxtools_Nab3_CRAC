#!/usr/bin/env bash
#SBATCH --job-name=sra_download
#SBATCH --array=0-20
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --output=sra_download_%A_%a.out
#SBATCH --error=sra_download_%A_%a.err

set -euo pipefail

# Load the SRA Toolkit on your cluster if required.
# module load sra-toolkit

command -v fasterq-dump >/dev/null 2>&1 || {
    echo "Error: fasterq-dump was not found in PATH" >&2
    exit 1
}

ACCESSIONS=(
    SRR5388374
    SRR5388375
    SRR5388376
    SRR5388377
    SRR5388378
    SRR5388379
    SRR5388380
    SRR5388474
    SRR5388475
    SRR5388476
    SRR5388477
    SRR5388478
    SRR5388479
    SRR5388480
    SRR5388481
    SRR5388482
    SRR5388483
    SRR5388484
    SRR5388485
    SRR5388486
    SRR5388487
)

ACCESSION="${ACCESSIONS[$SLURM_ARRAY_TASK_ID]}"
OUTDIR="${SLURM_SUBMIT_DIR}"
TMPDIR="${SLURM_TMPDIR:-${TMPDIR:-/tmp}}/sra_${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}"

mkdir -p "$OUTDIR" "$TMPDIR"

cleanup() {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

echo "Downloading ${ACCESSION}"
echo "Output directory: ${OUTDIR}"
echo "Temporary directory: ${TMPDIR}"

fasterq-dump \
    --threads "$SLURM_CPUS_PER_TASK" \
    --temp "$TMPDIR" \
    --outdir "$OUTDIR" \
    --split-files \
    "$ACCESSION"

find "$OUTDIR" -maxdepth 1 -type f \
    \( -name "${ACCESSION}.fastq" -o -name "${ACCESSION}_*.fastq" \) \
    -print0 |
    xargs -0 -r gzip -f

echo "Finished ${ACCESSION}"