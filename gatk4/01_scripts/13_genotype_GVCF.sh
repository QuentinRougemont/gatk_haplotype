#!/bin/bash
#SBATCH -J "coho"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=07-00:00
#SBATCH --mem=18G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#########################################################
#last update: 28-05-2019
#SCRIPT TO RUN gatk genotyper from gatkv4.0.9 in GVCF mode
#INPUT: 1 gvcf obtain the script 12
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file 
########################################################

#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#in terminal: create a list of GVCF to copy in the gatk command:
#for i in $(ls 10-gatk_GVCF/*gz ) ; do echo -e "\t -V" $i \\ ; done  > list_vcf

#Global variables
OUTFOLDER="12-genoGVCF"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

file_path=$(pwd)

#PATH TO ref genome:
REF="$file_path/03_genome/GCF_002021735.1_Okis_V1_genomic.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi

################## run gatk ########################################
echo "#####"
echo "GENOTYPING samples "
echo "######"
gatk --java-options "-Xmx57G" \
	GenotypeGVCFs \
        -R "$REF" \
	-V 11-CombineGVCF/combinedGVCF.vcf.gz \
	-all-sites true \
	--heterozygosity 0.015 \
	--indel-heterozygosity 0.01 \
	-O "$file_path"/"$OUTFOLDER"/GVCFall.vcf.gz \
