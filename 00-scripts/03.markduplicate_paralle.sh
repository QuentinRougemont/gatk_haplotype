#!/bin/bash
#SBATCH -J "fix_bam"                          
#SBATCH -o log_%j                          
#SBATCH -c 1                               
#SBATCH -p medium
##SBATCH -p ibismax                         
##SBATCH -A ibismax                         
#SBATCH --mail-type=FAIL                   
#SBATCH --mail-user=YOUREMAIL              
#SBATCH --time=02-00:00                    
#SBATCH --mem=50G                          

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR                       
# Global variables
#NUM_CPUS=10
java -jar /prg/picard-tools/1.119/MarkDuplicates.jar \
	INPUT=sorted.bern9.bam \
	OUTPUT=sorted.bern9.dedup.bam \
	METRICS_FILE=metrics.txt \
	VALIDATION_STRINGENCY=LENIENT

exit
maxid=$(ls -1 03-bam_files/*.bam | wc -l)
seq $maxid | parallel -j $NUM_CPUS ./00-scripts/02-markduplicate_iteration.sh
