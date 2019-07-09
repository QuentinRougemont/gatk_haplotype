#!/bin/bash
#SBATCH -J "coho"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06-00:00
#SBATCH --mem=08G
# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#run script
./01-scripts/11_extract_VQSR_indel.sh
