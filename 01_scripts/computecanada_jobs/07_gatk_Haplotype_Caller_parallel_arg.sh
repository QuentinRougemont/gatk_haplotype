#!/bin/bash
#SBATCH --account=youraccount
#SBATCH --time=24:00:00
#SBATCH --job-name=job_name
#SBATCH --output=job-%J.out
#SBATCH --mem=20G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-24 #set size according to number of chromosome for instance
##SBATCH --cpus-per-task=32

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#NCPUS=32

listintervals=$1 #interval.list 
file=$2          #individual bam file to work on  
wanted=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $listintervals )
#for SGE replace "SLURM_ARRAY_TASK_ID" by "SGE_TASK_ID" and replace the header accordingly

#launch gatk:
./01_scripts/07_gatk_haplotype_caller_iteration.sh $wanted $file

exit
#cat $listintervals |parallel -j $NCPUS ./01_scripts/07_gatk_haplotype_caller_iteration.sh {} $file 
