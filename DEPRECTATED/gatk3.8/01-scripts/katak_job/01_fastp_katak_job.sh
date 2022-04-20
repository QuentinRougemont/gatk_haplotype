#!/bin/bash
#SBATCH -J "fastp_chinook"
#SBATCH -o log_%j
#SBATCH -c 6
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=05-00:00
#SBATCH --mem=10G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#run script
./01-scripts/01_fastp.sh
