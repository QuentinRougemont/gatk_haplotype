#!/bin/bash
#PBS -A ihv-653-aa
#PBS -N merge__
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=8
#PBS -r n

# Move to job submission directory
cd $PBS_O_WORKDIR

source /clumeq/bin/enable_cc_cvmfs
module load nixpkgs/16.09  gcc/5.4.0
module load samtools
module load picard/2.20.6

cd /rap/ihv-653-ab/quentin/14.epic4

GENOMEFOLDER="03_genome"
GENOME="your.fasta"
DICT="$GENOMEFOLDER"/"${GENOME%.fasta}".dict

# create a dictionnary from reference fasta file
java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary \
      R="$GENOMEFOLDER"/"$GENOME" \
      O="$DICT"

#index
samtools faidx "$GENOMEFOLDER"/"$GENOME"

