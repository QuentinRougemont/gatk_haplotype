#!/bin/bash
#SBATCH -J "gatk"                          
#SBATCH -o log_%j                          
#SBATCH -c 10                               
#SBATCH -p low-suspend 
##SBATCH -p ibismax                         
##SBATCH -A ibismax                         
#SBATCH --mail-type=FAIL                   
#SBATCH --mail-user=YOUREMAIL              
#SBATCH --time=58:30:00                    
#SBATCH --mem=180G                          

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR                       

# Global variables
NUM_CPUS=10
OUTFOLDER="04-results"

if [[ ! -d "$OUTFOLDER" ]]
then
    echo "creating foleder"
    mkdir "$OUTFOLDER"
fi

maxid=$(ls -1 04-bam_files_fixed/*.bam | wc -l)
seq $maxid | parallel -j $NUM_CPUS ./00-scripts/03-gatk_haplotype_iteration.sh
