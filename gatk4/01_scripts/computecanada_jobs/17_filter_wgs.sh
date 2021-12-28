#!/bin/bash
#SBATCH --account=your-account
#SBATCH --time=60:00:00
#SBATCH --job-name=filtration
#SBATCH --output=filtration-%J.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
##SBATCH --cpus-per-task=32
#SBATCH --mem=6G
#SBATCH --array=1-30  ##array size match the total number of intervals

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

echo "filtering the whole vcf based on GATK hard filter"
./01_scripts/17_wgs_filtration.sh $SLURM_ARRAY_TASK_ID 

exit

