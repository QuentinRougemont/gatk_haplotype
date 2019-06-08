#!/bin/bash

#Global variables
INFOLDER="04-bam_files_fixed"
OUTFOLDER="04-results"
REF="02-genome/okis.genome.allpaths_v52488.2PE_30X_3MP_10X_15X_15X.pbjelly_all_pacbio.scaffolds_500bp.fasta"

id=$[ $1 - 1 ]
files=(04-bam_files_fixed/*.bam)
file=${files[$id]}
name=$(basename $file)

gatk --java-options "-Xmx57G" \
        HaplotypeCaller  \
        -R "$REF" \
        -I "$file" \
        -O "$OUTFOLDER"/"$name".variants \
        --genotyping-mode DISCOVERY \
        --min-base-quality-score 18 \
        --output-mode EMIT_ALL_SITES \
        -RF MappingQualityReadFilter \
        --minimum-mapping-quality 20 \
        -stand-call-conf 30

echo -e "$id" > 10-log_files/log."id"

id=$(echo $id + 1 | bc)
