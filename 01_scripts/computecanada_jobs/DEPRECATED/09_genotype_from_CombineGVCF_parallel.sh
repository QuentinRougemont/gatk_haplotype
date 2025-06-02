#!/bin/bash
#SBATCH --account=youraccount
#SBATCH --time=06:00:00
#SBATCH --job-name=job_name
#SBATCH --output=job-%J.out
#SBATCH --mem=125G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=30

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

NCPUS=30
#make sur to have parallel loaded or in your .bashrc

input=$1 #ls 10-gatk_parallel/*gz > inputlist 
#input should be the list of all g.vcf 

cat $input |\
    parallel -j $NCPUS ./01_scripts/09_genotype_iteration.sh {} 

