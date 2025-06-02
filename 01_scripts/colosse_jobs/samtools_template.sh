#!/bin/bash
#PBS -A ihv-653-aa
#PBS -N samtools__LIST__
#PBS -o samtools__LIST__.out
#PBS -e samtools__LIST__.err
#PBS -l walltime=20:00:00
#PBS -M YOUREMAIL
####PBS -m ea
#PBS -l nodes=1:ppn=8
#PBS -r n

# Global variables
list=__LIST__

# Move to job submission directory
cd $PBS_O_WORKDIR

# Load gmap module
source /clumeq/bin/enable_cc_cvmfs
module load samtools/1.5
module load bwa/0.7.15

# Global variables
DATAFOLDER="04.raw"

for file in $(cat $list)
do
    # Name of uncompressed file
    echo "sort file $file"

    name=$(basename $file)
    samtools sort $DATAFOLDER/"${name%.fq.gz}".bam  > $DATAFOLDER/"${name%.fq.gz}".sort.bam
    echo "index file $file"

    samtools index $DATAFOLDER/"${name%.fq.gz}".sort.bam
done
