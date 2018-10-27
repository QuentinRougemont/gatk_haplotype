#!/bin/bash
#SBATCH -J "sort"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p small
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=20:00:00
#SBATCH --mem=36G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

###########################################################
#last update: 15-10-2018
#SCRIPT TO sort, mark duplicate and index the bam
#INPUT: 1 bam file per individual
#OUTPUT : 1 sorted and indexed bam without dup
########################################################
#https://gatkforums.broadinstitute.org/gatk/discussion/2799/howto-map-and-mark-duplicates
#see also: http://www.htslib.org/doc/samtools.html

#Global variable
file=$1 #name of the bam file
if [ -z "$file" ]
then
    echo "Error: need bam name (eg: sample1.bam)"
    exit
fi
#id=$[ $1 - 1 ]
#files=(04-bam_files_fixed/*.bam)
#file=${files[$id]}
name=$(basename $file)
#
INFOLDER="04-bam_files_fixed"
OUTFOLDER="05-bam_files_def"
TMPFOLDER="TMPFOLDER"
if [ ! -d "$OUTFOLDER" ]
then
	echo "creating folder"
	mkdir "$OUTFOLDER" 
fi
if [ ! -d "$TMPFOLDER" ]
then
	echo "creating folder"
	mkdir "$TMPFOLDER" 
fi

#path to picard
#picard="/home/qurou/software/picard_tools/picard.jar"
picard="/prg/picard-tools/1.119/MarkDuplicates.jar" 
sortsam="/prg/picard-tools/1.119/SortSam.jar"
build="/prg/picard-tools/1.119/BuildBamIndex.jar"
picar="/prg/picard-tools/1.119/picard-1.119.jar"
###### create log ##################
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="10-log_files"
SCRIPT=$0
NAME=$(basename $0)
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"
#####################################
echo $picar
echo $picard
echo "file is" $file
echo "name is "$name
echo "TMPFOLDER is" $TMPFOLDER

#run picard
#sort
#echo -e "
java -jar "$sortsam" \
    INPUT="$file" \
    OUTPUT=$TMPFOLDER/"${name%.bam}".sorted_reads.bam \
    SORT_ORDER=coordinate \
    VALIDATION_STRINGENCY=LENIENT
#exit
#Mark duplicates
java -jar "$picard"  \
    INPUT=$TMPFOLDER/"${name%.bam}".sorted_reads.bam \
    OUTPUT=$OUTFOLDER/"${name%.bam}".dedup_reads.bam \
    METRICS_FILE=metrics.txt \
    VALIDATION_STRINGENCY=LENIENT

#index
java -jar "$build" \
    INPUT=$OUTFOLDER/"${name%.bam}".dedup_reads.bam \
    VALIDATION_STRINGENCY=LENIENT

# id=$(echo $id + 1 | bc)

#rm $TMPFOLDER/*
