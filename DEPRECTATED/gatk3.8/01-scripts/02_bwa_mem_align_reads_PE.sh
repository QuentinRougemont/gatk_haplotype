#!/bin/bash

#########################################################
#script to align PE Reads
# Global variables
GENOMEFOLDER="02_genome"
GENOME="genome.fasta"
RAWDATAFOLDER="04_trimmed/" #each folder contain a bam, run all bam in parallel
ALIGNEDFOLDER="05_aligned"
NCPU=$1
#data were cleaned with fastp

# Test if user specified a number of CPUs
if [[ -z "$NCPU" ]]
then
    NCPU=4
fi
if [ -d "$ALIGNEDFOLDER" ]
then
    echo "creating out-dir"
    mkdir "$ALIGNEDFOLDER"
fi

# Load needed modules
module load bwa
module load samtools/1.8

# Index genome if not alread done
#bwa index -p "$GENOMEFOLDER"/"$GENOME" "$GENOMEFOLDER"/"$GENOME"

# Iterate over sequence file pairs and map with bwa
for file in $(ls -1 "$RAWDATAFOLDER"/*_1.trimmed.fastq.gz)
do
    # Name of uncompressed file
    file2=$(echo "$file" | perl -pe 's/_1\.trimmed/_2.trimmed/')
    echo "Aligning file $file $file2" 

    name=$(basename "$file")
    name2=$(basename "$file2")
    ID="@RG\tID:ind\tSM:ind\tPL:Illumina"

    # Align reads
    bwa mem -t "$NCPU" -R "$ID" "$GENOMEFOLDER"/"$GENOME" "$RAWDATAFOLDER"/"$name" "$RAWDATAFOLDER"/"$name2" |
    samtools view -Sb -q 10 - |
    samtools sort - > "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam
    # Index
    samtools index "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam
done
