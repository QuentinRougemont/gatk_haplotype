#!/bin/bash

#########################################################
#AUTHOR Q. Rougemont
#DATE : June 2019
#Purpose: script to trimm fastq data using trimmomatic
#########################################################

#test if folder exists:
if [ -z "$(ls -A 04_raw_data/)" ]; then
   echo "Error Empty folder"
   echo "Raw fastq should be stored here"
   exit
fi

if [ ! -d "05_trimmed" ]
then
    mkdir 05_trimmed
fi

trimo=/home/qurou/software/Trimmomatic-0.39/trimmomatic-0.39.jar 
module load java
#on fastq by subfolder "file1" and runs all in parallel
for file in $(ls -1 04_raw_data/file1/*_R1.fastq.gz)
do
    input_file=$(echo "$file" | perl -pe 's/_R1.fastq.gz//')
    output_file=$(basename "$input_file")
    echo "Treating: $output_file"

 java -Xmx4g -jar $trimo PE \
    -threads 1 \
    -phred33 \
    "$input_file"_R1.fastq.gz "$input_file"_R2.fastq.gz \
    05_trimmed/"$output_file"_R1_cleaned.fastq.gz \
    05_trimmed/"$output_file"_R1_cleaned_unpaired.fastq.gz \
    05_trimmed/"$output_file"_R2_cleaned.fastq.gz \
    05_trimmed/"$output_file"_R2_cleaned_unpaired.fastq.gz \
    ILLUMINACLIP:/home/qurou/software/Trimmomatic-0.39/adapters/TruSeq3-PE-2.fa:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50

done
