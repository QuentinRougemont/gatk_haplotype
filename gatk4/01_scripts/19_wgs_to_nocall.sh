#!/bin/bash
#SBATCH -J "nocall"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=07-00:00
#SBATCH --mem=10G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 10-05-2019
#Purpose: Script to filter the complete genome gatkv4.0.9
#INPUT: 1 whole gvcffile
#OUTPUT : 1 whole gvcfile with bad sites set as nocall
########################################################

file=$1 #name of the vcf file 
if [ -z "$file" ]
then
    echo "Error: need clean vcf file"
    exit
fi

name=$(basename $file)

OUTFOLDER="18-wgs_no_call"
if [ ! -d "$OUTFOLDER" ]
then
    mkdir "$OUTFOLDER"
fi

FILE_PATH="$(pwd)" 

################## run gatk ########################################
gatk --java-options "-Xmx57G" \
    SelectVariants\
    --set-filtered-gt-to-nocall \
    -V "$FILE_PATH"/"$file" \
    -O "$OUTFOLDER"/"${name%.vcf.gz}".cleaned.vcf.gz 
