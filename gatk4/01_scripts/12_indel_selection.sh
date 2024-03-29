#!/bin/bash
#SBATCH -J "job_name"
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
#AUTHOR: Q. Rougemont
#Date : June 2019
#Purpose: SCRIPT To select Indels variant from gatk-4.1.2.0
#INPUT: 1 vcf file fro GenotypeGVCFs
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file with Indels only (for all individuals) 
########################################################

#Global variables
gvcfall=$1     #vcf file from joint genotyping
if [ -z $gvcfall ];
then
    echo "error no input vcf provided"
    exit
fi

#Global variables
#ceate folder:
OUTFOLDER="13-indel_VCF"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

FILE_PATH=$(pwd)

################## run gatk ########################################
echo "############# Running GATK ###########"
echo "# extracting indel from whole vcf.gz #"
gatk --java-options "-Xmx7G" \
    SelectVariants \
    -V  "$gvcfall" \
    --select-type-to-include INDEL\
    -O "$FILE_PATH"/"$OUTFOLDER"/GVCFall_INDEL.vcf.gz 
