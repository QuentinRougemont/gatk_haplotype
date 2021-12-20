#!/bin/bash
#SBATCH --account=your_account
#SBATCH --time=07-00:00
#SBATCH --job-name=gatk
#SBATCH --output=gatk-%J.out
#SBATCH --mem=180G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#prepare interval file:
#exemple pour les 29 chromosome du saumon:
#for i in $(seq 29 ) ; do sed -n "$i"p chr1_29 > chr_"$i".intervals ; done 
NCPUS=40

listintervals=$1 #interval.list 
module load java/13.0.2
echo "running combine GVCF in interval"
echo "list instervals is $listintervals" 

cat $listintervals |parallel -j $NCPUS ./01_scripts/08_Combine_iteration.sh {}  
