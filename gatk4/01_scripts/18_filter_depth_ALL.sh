#!/bin/bash
#SBATCH -J "DP_filtration"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=05-00:00
#SBATCH --mem=10G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 10-05-2019
#Purpose: Script to filter on depth
#INPUT: 1 vcf file
#OUTPUT : 1 vcf file with lowdepth flagged
########################################################

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="99-log_files"
SCRIPT=$0
NAME=$(basename $0)

#Global variables
file=$1 #name of the vcf file 
if [ -z "$file" ]
then
    echo "Error: need clean vcf file"
    exit
fi

name=$(basename $file)

OUTFOLDER="17-wgs_filter_DP"
if [ ! -d "$OUTFOLDER" ]
then
    mkdir "$OUTFOLDER"
fi

#path to the local dir
FILE_PATH=$(pwd)

################## run gatk ########################################
gatk --java-options "-Xmx57G" \
    VariantFiltration \
    -O "$OUTFOLDER"/"${name%.vcf.gz}".filterDP.vcf.gz \
    -V "$FILE_PATH"/"$file" \
    --genotype-filter-expression "DP < 10 || DP > 100" \
    --genotype-filter-name "DP-10-100"

