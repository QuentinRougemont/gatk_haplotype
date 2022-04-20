#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --job-name=job_name
#SBATCH --output=log_bwameme-%J.out
#SBATCH --mem=40G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#source /local/env/envconda3.sh 
#conda activate /path/to/mes_envs/samtools1.15

# Global variables
fastq=$1
NCPU=10  #generally use 4CPUs

GENOMEFOLDER="03_genome"
GENOME="yourgenome.fasta.gz"
RAWDATAFOLDER="05_trimmed/"
ALIGNEDFOLDER="06_aligned"

if [ ! -d "$ALIGNEDFOLDER" ]; 
then
   mkdir "$ALIGNEDFOLDER"
fi

# Iterate over sequence file pairs and map with bwa
for file in $fastq
do
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

done

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

#activate java if necessary
#.   /local/env/envjava-1.8.0.sh

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
#conda activate /path/to/mes_envs/samtools1.15

samtools index "$OUTFOLDER"/"$name"  
