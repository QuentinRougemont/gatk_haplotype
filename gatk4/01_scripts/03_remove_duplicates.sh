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

#########################################################
#AUTHOR Q. Rougemont
#DATE : June 2019
#Purpose: #script to remove duplicate
#INPUT: bam file
#OUTPUT: bam file with duplicated marks
#########################################################

### load module here if needed ##
#make sur to have picard.jar locally or in your bashrc

bam=$1
if [ $# -eq 0 ]
then
    echo "error need bam file "
    echo "bam should be in 06_aligned folder"
    exit
fi

# Global variables
DEDUPFOLDER="07_deduplicated"
METRICSFOLDER="99_metrics"

#create folders:
if [ ! -d "$DEDUPFOLDER" ]
then
    mkdir "$DEDUPFOLDER"
fi

if [ ! -d "$METRICSFOLDER" ]
then
    mkdir "$METRICSFOLDER"
fi

# Remove duplicates from bam alignments
for file in "$bam"
do
    echo "remove duplicate for file: $bam "
    java -Djava.io.tmpdir=./tmp -jar picard.jar  MarkDuplicates  \
        -INPUT "$file" \
        -OUTPUT "$DEDUPFOLDER"/$(basename "$file" .trimmed.sorted.bam).dedup.bam \
        -METRICS_FILE "$METRICSFOLDER"/metrics.txt \
        -VALIDATION_STRINGENCY SILENT \
        -REMOVE_DUPLICATES true  -TMP_DIR ./tmp
done

