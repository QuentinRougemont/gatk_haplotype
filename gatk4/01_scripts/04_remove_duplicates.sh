#!/bin/bash
#SBATCH -J "dedup"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=01-00:00
#SBATCH --mem=40G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

bam=$1
if [ $# -eq 0 ]
then
        echo "error need bam file "
	echo "bam should be in 06_aligned folder"
        exit
fi

# Global variables
MARKDUPS="/prg/picard-tools/1.119/MarkDuplicates.jar"
#ALIGNEDFOLDER="06_aligned/"
DEDUPFOLDER="07_deduplicated"
METRICSFOLDER="98_metrics"

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Load needed modules
module load java/jdk/1.8.0_102

# Remove duplicates from bam alignments
for file in "$bam"
do
#    java -jar "$MARKDUPS" \
    java -Xmx30g -Djava.io.tmpdir=./tmp -jar "$MARKDUPS" \
        INPUT="$file" \
        OUTPUT="$DEDUPFOLDER"/$(basename "$file" .trimmed.sorted.bam).dedup.bam \
        METRICS_FILE="$METRICSFOLDER"/metrics.txt \
        VALIDATION_STRINGENCY=SILENT \
        REMOVE_DUPLICATES=true \
	TMP_DIR=./tmp
done
