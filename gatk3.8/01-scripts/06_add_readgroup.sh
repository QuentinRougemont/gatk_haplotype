#!/bin/bash
#SBATCH -J "addRG"
#SBATCH -o log_%j
#SBATCH -c 1
##SBATCH -p small
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=1-00:00
#SBATCH --mem=18

# Global variables
file=$1 #bam files  provide all bam one by one to run one bam by cpu
if [ -z $file ]
then
	echo "error need bam file"
	exit
fi

picar="/home/qurou/software/picard_tools/picard.jar"

OUTFOLDER="09_cleanedbam"
if [ ! -d $OUTFOLDER ]
then
	mkdir $OUTFOLDER
fi

name=$(basename $file)

java -jar "$picar" AddOrReplaceReadGroups \
     I="$file"  \
     O="$OUTFOLDER"/"$name"  \
     RGLB=lib1 \
     RGPL=illumina \
     RGPU=barcode\
     RGSM="$name"\
     #VALIDATION_STRINGENCY=LENIENT


samtools index "$OUTFOLDER"/"$name"  
