#!/bin/bash
#SBATCH --account=your_account
#SBATCH --time=10:00:00
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

input=$1 #either alist of vcf splitted by intervals or a list of chromosome  or a list of intervals

echo "filter gvcf based on GATK on $input file"

cat $input |\
    parallel -j $NCPUS ./01_scripts/14_filter_iteration.sh {} #input
