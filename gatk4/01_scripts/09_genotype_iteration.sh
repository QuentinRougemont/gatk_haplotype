#!/bin/bash
#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 10-01-2021
#Purpose: Script to Run HaplotypeCaller from gatkv4. or later
#INPUT: 1 bam file per individual
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file per individual and chr
########################################################

vcfcomb=$1
vcf=$(basename $vcfcomb )
echo vcf is : $vcf
outvcf=$( echo $vcf |sed 's/combinedGVCF/genotype/g') 
echo output vcf will $outvcf 

OUTFOLDER="12-genoGVCF"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

FILE_PATH=$(pwd)
#PATH TO ref genome:
REF="$FILE_PATH/03_genome/yourfasta.fna"

################## run gatk ########################################
echo "############# Running GATK ###########"
echo "#     genotyping whole gvcf.gz       #"

gatk --java-options "-Xmx8G" \
    GenotypeGVCFs \
    -R "$REF" \
    -V "$vcfcomb" \
    -all-sites true \
    --heterozygosity 0.0015 \
    --indel-heterozygosity 0.001 \
    -O "$FILE_PATH"/"$OUTFOLDER"/$outvcf 

