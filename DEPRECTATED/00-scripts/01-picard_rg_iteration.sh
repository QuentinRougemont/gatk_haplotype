#!/bin/bash

# Global variables
picar="/home/qurou/software/picard_tools/picard.jar"

OUTFOLDER="04-bam_files_fixed"

id=$[ $1 - 1 ]
files=(03-bam_files/*.bam)
file=${files[$id]}
name=$(basename $file)

java -jar "$picar" AddOrReplaceReadGroups \
     I="$file"  \
     O="$OUTFOLDER"/"$name"  \
     RGID=12 \
     RGLB=lib1 \
     RGPL=illumina \
     RGPU=unit1 \
     RGSM="$id" \
     VALIDATION_STRINGENCY=LENIENT
 id=$(echo $id + 1 | bc)

