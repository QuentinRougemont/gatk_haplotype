#!/bin/bash
#SBATCH -J "job_name"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=07-00:00
#SBATCH --mem=18G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

#########################################################
#AUTHOR: Q. Rougemont
#Last update: 28-05-2019
#PURPOSE: Script to run GATK genotyper from gatkv4.0.9 in GVCF mode
#INPUT: 1 gvcf obtain the script 12_CombinedGVCF.sh
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file 
########################################################

#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#Global variables
#creating folder:
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="100-log_files"
if [ ! -d "$LOG_FOLDER" ]
then
    mkdir "$LOG_FOLDER"
fi
SCRIPT=$0
NAME=$(basename $0)
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

OUTFOLDER="12-genoGVCF"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

FILE_PATH=$(pwd)

#PATH TO ref genome:
REF="$FILE_PATH/03_genome/your_ref_genome.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi
gvcfcomb="$FILE_PATH/11-CombineGVCF/combinedGVCF.vcf.gz"
if [ -z $gvcfcomb ];
then
    echo "error no input vcf provided"
    exit
fi
################## run gatk ########################################
echo "############# Running GATK ###########"
echo "#     genotyping whole gvcf.gz       #"

gatk --java-options "-Xmx57G" \
    GenotypeGVCFs \
    -R "$REF" \
    -V "$gvcfcomb" \
    -all-sites true \
    --heterozygosity 0.0015 \
    --indel-heterozygosity 0.001 \
    -O "$FILE_PATH"/"$OUTFOLDER"/GVCFall.vcf.gz 
