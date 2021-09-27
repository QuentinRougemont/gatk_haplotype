#!/bin/bash
#SBATCH --account=your_account
#SBATCH --time=24:00:00
#SBATCH --job-name=gatk
#SBATCH --output=gatk-%J.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=80

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

NCPUS=80

listintervals=$1 #interval.list 

echo "runnung genomics_DB_import in parallel for $listintervals"

#load module if necessary
#module load gnu-parallel/20191122
#module load java/1.8.0_201

cat $listintervals |parallel -j $NCPUS ./01_scripts/08_genomicsDBImport.sh {}  
