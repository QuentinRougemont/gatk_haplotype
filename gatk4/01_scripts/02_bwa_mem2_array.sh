#!/bin/bash

file=$1

NCPU=1
GENOME="your.genome.fna.gz"
GENOMEFOLDER=03-genome
RAWDATAFOLDER=04-trimmed
ALIGNEDFOLDER=05-aln 
mkdir 05-aln 2>/dev/null


file2=$(echo "$file" | perl -pe 's/1.trimmed/2.trimmed/')

echo "Aligning file $file $file2" 

name=$(basename "$file")
name2=$(basename "$file2")
ID="@RG\tID:ind\tSM:ind\tPL:Illumina"

# Align reads
bwa-mem2 mem -t "$NCPU" -R "$ID" "$GENOMEFOLDER"/"$GENOME" "$RAWDATAFOLDER"/"$name" "$RAWDATAFOLDER"/"$name2" | samtools view -bS -q 19 - > "$ALIGNEDFOLDER"/"${name%.1.trimmed.fq.gz}".bam

# Sort
samtools sort --threads "$NCPU" "$ALIGNEDFOLDER"/"${name%.1.trimmed.fq.gz}".bam  > "$ALIGNEDFOLDER"/"${name%.1.trimmed.fq.gz}".sorted.bam

# Index
samtools index  "$ALIGNEDFOLDER"/"${name%.1.trimmed.fq.gz}".sorted.bam

# Remove unsorted bam file
#"rm "$ALIGNEDFOLDER"/"${name%.1.trimmed.fq.gz}".bam
