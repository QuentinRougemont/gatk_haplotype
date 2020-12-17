#!/bin/bash
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
#cd $SLURM_SUBMIT_DIR

#########################################################
#AUTHOR Q. Rougemont
#DATE : June 2019
#Purpose: Script to add read group
#########################################################

# Global variables
file=$1 #bam files  provide all bam one by one to run one bam by cpu
if [ -z $file ]
then
    echo "error need bam file"
    exit
fi

name=$(basename $file)
name2=$(echo ${name%_1.dedup.bam} )
#Load picard:
picar="/home/qurou/software/picard_tools/picard.jar"

OUTFOLDER="08_cleaned_bam"
if [ ! -d $OUTFOLDER ]
then
    mkdir $OUTFOLDER
fi

java -jar "$picar" AddOrReplaceReadGroups \
     I="$file"  \
     O="$OUTFOLDER"/"$name"  \
     RGLB=lib1 \
     RGPL=illumina \
     RGPU=barcode\
     RGSM="$name2"\
     #VALIDATION_STRINGENCY=LENIENT

samtools index "$OUTFOLDER"/"$name"  
