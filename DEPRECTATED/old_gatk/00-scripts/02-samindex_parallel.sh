#!/bin/bash
#SBATCH -J "ind_bam"                          
#SBATCH -o log_%j                          
#SBATCH -c 10                               
#SBATCH -p low-suspend
##SBATCH -p ibismax                         
##SBATCH -A ibismax                         
#SBATCH --mail-type=FAIL                   
#SBATCH --mail-user=YOUREMAIL              
#SBATCH --time=10-00:00                    
#SBATCH --mem=30G                          

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR                       

# Global variables
NUM_CPUS=10

maxid=$(ls -1 03-bam_files/*.bam | wc -l)
seq $maxid | parallel -j $NUM_CPUS ./00-scripts/02-samindex_iteration.sh
