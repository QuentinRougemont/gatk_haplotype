#!/bin/bash
#SBATCH -J "indel_rainbow"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=05-00:00
#SBATCH --mem=15G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#########################################################
#AUTHOR Q. Rougemont
#DATE : June 2019
#Purpose: script to realign indel
#########################################################

bam=$1
if [ $# -eq 0 ]
then
    echo "error need bam file"
    echo "bam should be in 08_cleaned_bam"
    exit
fi

# Global variables
REALIGNFOLDER="09_realigned"
#create folders:
if [ ! -d "$REALIGNFOLDER" ]
then
    mkdir "$DEDUPFOLDER"
fi

GENOMEFOLDER="03_genome"
GENOME="your_genome.fasta"

#verify that genome folder contains the genome:
#test if folder exists:
if [ -z "$(ls -A 03_genome/)" ]; then
   echo "Error Empty folder"
   echo "The folder 03_genome should contain the fasta ref"
   exit
fi
# Load needed modules
module load java/jdk/1.8.0_102

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)

LOG_FOLDER="100_log_files"
if [ ! -d "$LOG_FOLDER" ]
then
    mkdir "$LOG_FOLDER"
fi
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Realign around target previously identified
for file in "$bam"
do
    java -jar $GATK \
        -T IndelRealigner \
        -R "$GENOMEFOLDER"/"$GENOME" \
        -I "$file" \
        -targetIntervals "${file%.bam}".intervals \
        --consensusDeterminationModel USE_READS  \
        -o "$REALIGNFOLDER"/$(basename "$file" .dedup.bam).realigned.bam
done
