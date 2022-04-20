#!/bin/bash
#SBATCH -J "bwamem_chinook"
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
module load bwa
module load samtools/1.8

#run script
./01-scripts/02_bwa_mem_align_reads_PE.sh
