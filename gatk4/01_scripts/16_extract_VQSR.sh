#!/bin/bash
#SBATCH -J "VQSR"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06-00:00
#SBATCH --mem=08G
# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

#########################################################
#Author: Q. Rougemont
#last update: 28-05-2019
#SCRIPT TO extract vqsr with gatkv4.0.9
#INPUT: 1 vcf file
#OUTPUT : table of VQSR
########################################################

#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#Global variables
file=$1 #input vcf.gz file  #either SNP, indel or WGS vcf file
if [ -z "$file" ]
then
    echo "Error: need compressed vcf.gz file"
    exit
fi

name=$(basename $file)

#path to the local dir
FILE_PATH=$(pwd)

################## run gatk ########################################
gatk --java-options "-Xmx57G" \
    VariantsToTable \
    -V "$file" \
    -F CHROM -F POS -F ID  -F REF -F ALT -F QUAL -F QD -F DP -F MQ -F MQRankSum -F FS -F ReadPosRankSum -F SOR \
    -O "$FILE_PATH"/"${name%.vcf.gz}".table  \

gzip "$FILE_PATH"/"${name%.vcf.gz}".table  \
