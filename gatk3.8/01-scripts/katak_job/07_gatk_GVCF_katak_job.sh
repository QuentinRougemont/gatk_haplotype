#!/bin/bash
#SBATCH -J "coho"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06-00:00
#SBATCH --mem=20G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR


#Global variables
file=$1 #name of the bam file
if [ -z "$file" ]
then
    echo "Error: need bam name (eg: sample1.bam)"
    exit
fi

#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#run script
./01-scripts/07_gatk_GVCF.sh
