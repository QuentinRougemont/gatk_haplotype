#!/bin/bash
#SBATCH -J "coho"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06-00:00
#SBATCH --mem=16G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR


#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0
#in terminal: create a list of GVCF to copy in the gatk command:
#for i in $(ls 09-gatk_GVCF/*gz ) ; do echo -e "\t -V" $i \\ ; done  > list_vcf


#run script
./01-scripts/08_genotypeGVCF.sh
