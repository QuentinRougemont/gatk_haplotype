#!/bin/bash
#SBATCH -J "job_name"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06-00:00
#SBATCH --mem=20G
# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 10-05-2019
#Purpose: Script to Run HaplotypeCaller from gatkv4.0.9 in GVCF mode
#INPUT: 1 bam file per individual
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file per individual
########################################################
#use this to process a single individual withouth splitting
#good if you have only few threads available

#Global variables
file=$1 #name of the bam file 
if [ -z "$file" ]
then
    echo "Error: need bam name (eg: sample1.bam)"
    exit
fi

name=$(basename $file)
OUTFOLDER="09-gatk_GVCF" 
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
################## run gatk ########################################
echo "############# Running GATK ###########"
echo "Running haplotypcaller for file $name "
gatk --java-options "-Xmx7G" \
    HaplotypeCaller \
    -R "$REF" \
    --native-pair-hmm-threads 8\
    -I "$FILE_PATH"/"$file" \
    -ERC GVCF \
    --heterozygosity 0.0015 \
    --indel-heterozygosity 0.001 \
    -O "$FILE_PATH"/"$OUTFOLDER"/"${name%.bam}".g.vcf.gz 
