#!/bin/bash
#SBATCH --account=your_account
#SBATCH --time=24:00:00
#SBATCH --job-name=gatk
#SBATCH --mem=50G
#SBATCH --output=gatk-%J.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-160 

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#module load bwa-mem2/2.2.1
#module load samtools/1.17
#set the array size according to the number of intervals!

listintervals=$1 

wanted=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $listintervals )

./01_scripts/02_bwa_mem2_array.sh $wanted
