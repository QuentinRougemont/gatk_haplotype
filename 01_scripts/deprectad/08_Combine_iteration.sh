#!/bin/bash

id=$[ $1  ]
intervals=chr_"$id".intervals 
echo "id is : $id"

#creating folder:
OUTFOLDER="10-CombineGVCF" 
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

FILE_PATH=$(pwd)

################## run gatk ########################################
echo "############# Running GATK ###########"

gatk --java-options "-Xmx57G" \
    CombineGVCFs \
	 -V 10-gatk_parallel/file1."$intervals".intervals.g.vcf.gz  \
	 -V 10-gatk_parallel/fil2."$intervals".intervals.g.vcf.gz  \
    -O "$FILE_PATH"/"$OUTFOLDER"/combinedGVCF."$intervals".vcf.gz 

