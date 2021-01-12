#!/bin/bash
#SBATCH --account=youraccount
#SBATCH --time=24:00:00
#SBATCH --job-name=ldhat
#SBATCH --output=ldhat-%J.out
##SBATCH --array=1-33%33
#SBATCH --mem=125G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32
##SBATCH --gres=cpu:32
##SBATCH --mail-user=yourmail
##PBS -l nodes=1:ppn=8
##SBATCH --mail-type=EA 

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

NCPUS=32

listintervals=$1 #interval.list 
file=$2          #individual bam file to work on  

cat $listintervals |parallel -j $NCPUS ./07_gatk_iteration.sh {} $file 
