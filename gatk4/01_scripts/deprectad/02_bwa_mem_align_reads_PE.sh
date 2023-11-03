#!/bin/bash
#SBATCH -J "bwamem"
#SBATCH -o log_%j
#SBATCH -c 4
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=05-00:00
#SBATCH --mem=10G
# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#PURPOSE: performs Paired-End alignment of fastq files on reference genome
#INPUT: fastq file, Ref genome
#OUTPUT: bam file

# Global variables
fastq=$1
NCPU=$2  #generally use 4CPUs

if [ $# -eq 0 ]
then
        echo "error need fastq file"
        exit
fi

GENOMEFOLDER="03_genome"
GENOME="your_reference_genome.fasta"
RAWDATAFOLDER="05_trimmed"
ALIGNEDFOLDER="06_aligned"

if [ ! -d "$ALIGNEDFOLDER" ]; 
then
   mkdir "$ALIGNEDFOLDER"
fi

#verify that genome folder contains the genome:
if [ -z "$(ls -A 03_genome/)" ]; then
   echo "Error Empty folder"
   echo "The folder 03_genome should contain the fasta ref"
   exit
fi

# Test if user specified a number of CPUs
if [[ -z "$NCPU" ]]
then
    NCPU=4
fi

# Load needed modules
module load bwa
module load samtools/1.8

# Index genome if not alread done
#bwa index -p "$GENOMEFOLDER"/"$GENOME" "$GENOMEFOLDER"/"$GENOME"

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
    bwa mem -t "$NCPU" -R "$ID" "$GENOMEFOLDER"/"$GENOME" "$RAWDATAFOLDER"/"$name" "$RAWDATAFOLDER"/"$name2" |
    samtools view -Sb -q 20 - > "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam

    # Sort
    samtools sort --threads "$NCPU" "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam \
        > "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam

    # Index
    samtools index  "$ALIGNEDFOLDER"/"${name%.fastq.gz}".sorted.bam

    # Remove unsorted bam file
    rm "$ALIGNEDFOLDER"/"${name%.fastq.gz}".bam
done
