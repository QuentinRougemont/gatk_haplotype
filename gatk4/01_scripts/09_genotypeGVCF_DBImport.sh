#!/bin/bash
#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 15-09-2021
#Purpose: Script to Run genotypeGVCF from gatkv4 or later
#INPUT: database 
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file per individual and chr
########################################################

id=$[ $1  ]
intervals=chr_"$id".intervals
database=database."$intervals"  #database name

OUTFOLDER="12-genoGVCF"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

FILE_PATH=$(pwd)
#PATH TO ref genome:

################## run gatk ########################################
echo "############# Running GATK ###########"
echo "#     genotyping whole gvcf.gz       #"

gatk --java-options "-Xmx8g" GenotypeGVCFs \
   -V gendb://$database \
   -O $OUTFOLDER/$intervals.vcf.gz \
    -L "$FILE_PATH"/INTERVAL/$intervals \
    --all-sites true \
    --heterozygosity 0.0015 \
    --indel-heterozygosity 0.001 \
   --tmp-dir tmp
