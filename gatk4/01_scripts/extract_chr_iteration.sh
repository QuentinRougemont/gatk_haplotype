#!/bin/bash
#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 10-01-2021
#Purpose: Script to extract some chr
#INPUT: 1 g.vcf file
#INPUT: 1 chr list 
#OUTPUT: 1 vcf file per individual and with the wanted chr
#########

vcfcomb=$2
vcf=$(basename $vcfcomb )
echo vcf is : $vcf
outvcf=$( echo $vcf |cut -d "." -f 1 ) 
echo output vcf will $outvcf 

chr=$1
echo chr is : $chr

OUTFOLDER="10-newchr"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

FILE_PATH=$(pwd)
REF="$FILE_PATH/03_genome/GCF_002021735.2_Okis_V2_genomic.fna"

################## run gatk ########################################
echo "############# Running GATK ###########"
echo "#     genotyping whole gvcf.gz       #"

gatk --java-options "-Xmx8G" \
     SelectVariants \
    -R "$REF" \
    -V "$vcfcomb" \
    -L "$chr"\
    -O "$FILE_PATH"/"$OUTFOLDER"/"$outvcf"."$chr".g.vcf.gz

