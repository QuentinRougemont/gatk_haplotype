#!/bin/bash

#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 10-01-2021
#Purpose: Script to Run HaplotypeCaller from gatkv4. or later
#INPUT: 1 bam file per individual
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file per individual and chr
########################################################

## GLOBAL VARIABLE
id=$[ $1  ]
intervals=chr_"$id".intervals 
echo "id is : $id"
file=$2 #name of the bam file 
echo "file is $file"
name=$(basename $file)

## FICHIER
OUTFOLDER="09-gatk_parallel"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

file_path=$(pwd)

## GENOME
REF="$file_path/03_genome/yourfasta.fna"

## GATK
## set heterozygosity for indel and snp according to your species characteristics
################## run gatk ########################################
echo "Running GATK for file $name "
gatk  \
    HaplotypeCaller \
    -R "$REF" \
    -I "$file_path"/"$file" \
    -ERC GVCF \
    --heterozygosity 0.0015 \
    --indel-heterozygosity 0.001 \
    --intervals "$file_path"/INTERVAL/$intervals \
    -O "$file_path"/"$OUTFOLDER"/"${name%.dedup.bam}".$intervals.g.vcf.gz 
