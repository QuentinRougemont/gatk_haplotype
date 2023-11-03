#!/bin/bash

#Design for job array on slurm Clusters:

# Global variables
file=$1 #fasq of read 1
NCPU=10  #generally use 4CPUs

GENOMEFOLDER="03_genome"
GENOME="yourgenome.fasta.gz"
RAWDATAFOLDER="05_trimmed/"
ALIGNEDFOLDER="06_aligned"

if [ ! -d "$ALIGNEDFOLDER" ]; 
then
   mkdir "$ALIGNEDFOLDER"
fi

# Name of uncompressed file
file2=$(echo "$file" | perl -pe 's/_1\.trimmed/_2.trimmed/')
echo "Aligning file $file $file2" 

name=$(basename "$file")
name2=$(basename "$file2")
ID="@RG\tID:ind\tSM:ind\tPL:Illumina"

# Align reads
/save/qrougemont/bwa-mem2-2.0pre2_x64-linux/bwa-mem2 mem -t "$NCPU" -R "$ID" "$GENOMEFOLDER"/"$GENOME" "$RAWDATAFOLDER"/"$name" "$RAWDATAFOLDER"/"$name2" |
samtools view -Sb -q 20 - > "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam

# Sort
samtools sort --threads "$NCPU" "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam \
    > "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam

# Index
samtools index  "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam

# Remove unsorted bam file
rm "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam
samtools view -c -F 260  "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam >> "$ALIGNEDFOLDER"/"${name%.fastq.gz}".comptage.txt

############################################################
### remove duplicate here
############################################################
## reinitialize name:
bam="$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam

DEDUPFOLDER="07_deduplicated"
METRICSFOLDER="99_metrics"
#create folders:
if [ ! -d "$DEDUPFOLDER" ]
then
    mkdir "$DEDUPFOLDER"
fi
if [ ! -d "$METRICSFOLDER" ]
then
    mkdir "$METRICSFOLDER"
fi
mkdir tmp
# Remove duplicates from bam alignments

for file in "$bam"
do
    echo "remove duplicate for file: $bam "
    java -Xmx8g -Djava.io.tmpdir=./tmp -jar picard.jar MarkDuplicates  \
        -INPUT "$file" \
        -OUTPUT "$DEDUPFOLDER"/$(basename "$file" .trimmed.sorted.bam).dedup.bam \
        -METRICS_FILE "$METRICSFOLDER"/metrics.txt \
        -VALIDATION_STRINGENCY SILENT \
        -REMOVE_DUPLICATES true  -TMP_DIR ./tmp
done
######################################################
## add readgroup 
#####################################################

#set names:
file="$DEDUPFOLDER"/$(basename "$file" .trimmed.sorted.bam).dedup.bam 
name=$(basename $file)
name2=$(echo ${name%.dedup.bam}.bam )

#prepare folder:
OUTFOLDER="08_cleaned_bam"
if [ ! -d $OUTFOLDER ]
then
    mkdir $OUTFOLDER
fi

echo "add Read Group for file : $name"
java -Xmx8g -jar picard.jar AddOrReplaceReadGroups \
     I="$file"  \
     O="$OUTFOLDER"/"$name"  \
     RGLB=lib1 \
     RGPL=illumina \
     RGPU=barcode\
     RGSM="$name2"\
     #VALIDATION_STRINGENCY=LENIENT

echo "now indexing"

samtools index "$OUTFOLDER"/"$name"  
