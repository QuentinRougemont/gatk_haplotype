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
#AUTHOR: Q. Rougemont
#Last update: 28-05-2019
#Purpose: Script To select SNP variant from gatk-4.1.2.0
#INPUT:   1 vcf file obtained after running GenotypeGVCFs
#INPUT:   1 fasta file (reference genome)
#OUTPUT : 1 vcf file with SNPs only (for all individuals) 
########################################################

#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#Global variables
OUTFOLDER="13-snp_GVCF"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

FILE_PATH=$(pwd)
REF="$FILE_PATH/03_genome/your_ref_genome.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi
gvcfall="$FILE_PATH/12-genoGVCF/GVCFall.vcf.gz"
if [ -z $gvcfall ];
then
    echo "error no input vcf provided"
    exit
fi
################## run gatk ########################################
echo "############# Running GATK ###########"
echo "# extracting SNPs from whole vcf.gz #"

gatk --java-options "-Xmx57G" \
    SelectVariants \
    -R "$REF" \
    -V "$gvcfall" \
    --select-type-to-include SNP \
    -O "$FILE_PATH"/"$OUTFOLDER"/GVCFall_SNPs.vcf.gz 
