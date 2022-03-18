#!/bin/bash

#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 18-03-2022
#Purpose: Script to filter whole vcf from gatkv4 or later
#INPUT: 1 vcf file from genotype vcf
#OUTPUT : 1 filtered vcf file per chromosome
########################################################
# /!\ WARNING /!\ #
#you should first plot the quality of your data and set the filter expression accordingly!
# /!\ WARNING /!\ #

id=$[ $1  ]
intervals=chr_"$id".intervals
database=database."$intervals"  #database name

vcfgeno=12-genoGVCF/${intervals}.vcf.gz

vcf=$(basename $vcfgeno )
echo vcf is : $vcf
outputvcf=${vcf%.vcf.gz}.filtered.vcf.gz
#outputvcf=$( echo $vcf |sed 's/genotype/filtered/g') 
#echo output vcf will $outputvcf 

FILE_PATH=$(pwd)
#PATH TO ref genome:
REF="$FILE_PATH/03_genome/your_fasta.fna"

OUTFOLDER="14-wgs_filter"
if [ ! -d "$OUTFOLDER" ]
then
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

gatk --java-options "-Xmx10G" \
    VariantFiltration \
    -R "$REF" \
    -O "$OUTFOLDER"/"$outputvcf \
    -V "$FILE_PATH"/"$vcfgeno" \
    --filter-name "FAILED_QUAL" --filter-expression "QUAL < 0" \
    --filter-name "FAILED_SOR"  --filter-expression "SOR > 4.000"\
    --filter-name "FAILED_MQ"   --filter-expression "MQ < 30.00" \
    --filter-name "FAILED_QD"   --filter-expression "QD < 2.00" \
    --filter-name "FAILED_FS"   --filter-expression "FS > 60.000" \
    --filter-name "FAILED_MQRS" --filter-expression "MQRankSum < -20.000" \
    --filter-name "FAILED_RPR"  --filter-expression "ReadPosRankSum < -10.000 || ReadPosRankSum > 10.000"
