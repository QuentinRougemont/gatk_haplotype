#!/bin/bash
#SBATCH -J "coho"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06-00:00
#SBATCH --mem=08G
# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#########################################################
#last update: 28-05-2019
#SCRIPT To select Indels variant from gatk-4.1.2.0
#INPUT: 1 vcf file fro GenotypeGVCFs
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file with Indels only (for all individuals) 
########################################################
#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#Global variables
OUTFOLDER="14-indel_GVCF"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

file_path=$(pwd)

REF="$file_path/03_genome/GCF_002021735.1_Okis_V1_genomic.fasta"

if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi
################## run gatk ########################################
echo "#####"
echo "extract  indel"
echo "######"
gatk --java-options "-Xmx57G" \
	SelectVariants \
        -R "$REF" \
	-V "$file_path"/12-genoGVCF/GVCFall.vcf.gz \
	--select-type-to-include INDEL\
	-O "$file_path"/"$OUTFOLDER"/GVCFall_INDEL.vcf.gz 
