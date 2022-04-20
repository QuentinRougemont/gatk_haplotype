#!/bin/bash
#SBATCH -J "dedup_coho"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=01-00:00
#SBATCH --mem=40G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR
module load java/jdk/1.8.0_102

bam=$1
if [ $# -eq 0 ]
then
    echo "error need bam file "
    echo "bam should be in 06_aligned folder"
    exit
fi

#run script
./01-scripts/03_rm_dup_and_index_sh
