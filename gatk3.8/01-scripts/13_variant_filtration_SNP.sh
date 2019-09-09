#!/bin/bash

#AUTHOR: Q. Rougemont

#DATE: June2019

#Purpose:
#script to filter SNP
########################################################################
#help
#to write

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="99-log_files"
SCRIPT=$0
NAME=$(basename $0)
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

#Global variables
file=11-snp_GVCF/GVCFall_SNPs.vcf.gz ##name of the vcf file 
if [ -z "$file" ]
then
    echo "Error: need vcf "
    exit
fi
name=$(basename $file)

OUTFOLDER="13-snp_filter"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

#path to local folder
file_path="${pwd}"
#path to genome
REF="$file_path/02_genome/GCF_002021735.1_Okis_V1_genomic.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi
################## run gatk ########################################
echo "#####"
echo "Keep nice SNP"
echo "######"
java -Xmx16g -jar /home/qurou/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
	-T VariantFiltration \
	-R "$REF" \
	-O "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz \
	-V "$ROAD"/"$file" \
	--filterExpression "QUAL < 0 || MQ < 30.00 || SOR > 4.000 || QD < 2.00 || FS > 60.000 || MQRankSum < -20.000 || ReadPosRankSum < -10.000 || ReadPosRankSum > 10.000" \
	--filterName "snp_filtration" 
	
gunzip "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz | \
	grep -E '^#|PASS'  > "$OUTFOLDER"/"${name%.vcf.gz}".filterPASSED.vcf
gzip "$OUTFOLDER"/"${name%.vcf.gz}".filterPASSED.vcf

