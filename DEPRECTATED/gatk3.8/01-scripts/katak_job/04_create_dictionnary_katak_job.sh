#!/bin/bash
#SBATCH -J "dict_rainbow_trout"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p small
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=01-00:00
#SBATCH --mem=15G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

# Load needed modules
module load java/jdk/1.8.0_102
module load samtools/1.8

#run script
./01-scripts/04_create_dictionnary.sh
