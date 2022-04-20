#!/bin/bash

#########################################################
#last update: 28-05-2019
#SCRIPT To select Indels variant from gatk-3.8
#INPUT: 1 vcf file fro GenotypeGVCFs
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file with Indels only (for all individuals) 
########################################################
#load module (on beluga only)
#module load java
#module load gatk/3.8

#Global variables
OUTFOLDER="12-indel_GVCF"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

#file_path="/home/quentin/scratch/10.GATK/coho"
file_path="${pwd}"

REF="$file_path/02_genome/GCF_002021735.1_Okis_V1_genomic.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi
################## run gatk ########################################
echo "#####"
echo "extract indel"
echo "######"
java -Xmx16g -jar /home/qurou/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
	-T SelectVariants \
        -R "$REF" \
	-V "$file_path"/10-combineGVCF/combinedGVCF.vcf.gz \
	-selectType INDEL\
	-o "$file_path"/"$OUTFOLDER"/GVCFall_INDEL.vcf.gz 
