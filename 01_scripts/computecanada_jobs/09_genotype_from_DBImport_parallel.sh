#!/bin/bash
#SBATCH --account=your_account
#SBATCH --time=24:00:00
#SBATCH --job-name=gatk
#SBATCH --output=gatk-%J.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
##SBATCH --cpus-per-task=80
#SBATCH --array=1-30

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#set the array size according to the number of intervals!

listintervals=$1 #interval list (here one id per chromosome but this can be any sort of intervals matchin gatk requirements ) 

echo "running joint genotyping in genomics_DB_import input in parallel mode for $listintervals"

wanted=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $listintervals )

./01_scripts/09_genotypeGVCF_DBImport.sh $wanted

