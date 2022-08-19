#!/bin/bash
#SBATCH --account=your_account
#SBATCH --time=10:00:00
#SBATCH --job-name=job_name
#SBATCH --output=job-%J.out
##SBATCH --mem=125G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
##SBATCH --cpus-per-task=32
#SBATCH --array=1-30 #set according to nraw of intervals 

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#NCPUS=32

listintervals=$1 #interval list (here one id per chromosome but this can be any sort of intervals matchin gatk requirements ) 
wanted=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $listintervals )

echo "filter gvcf based on GATK on $input file"

./01_scripts/14_filter_iteration.sh $wanted
