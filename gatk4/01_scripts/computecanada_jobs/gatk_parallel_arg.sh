#!/bin/bash
#SBATCH --account=youraccount
#SBATCH --time=24:00:00
#SBATCH --job-name=job_name
#SBATCH --output=job-%J.out
#SBATCH --mem=125G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

NCPUS=32

#make sur to have parallel loaded or in your .bashrc

listintervals=$1 #interval.list 
file=$2          #individual bam file to work on  

cat $listintervals |parallel -j $NCPUS ./01_scripts/07_gatk_iteration.sh {} $file 
