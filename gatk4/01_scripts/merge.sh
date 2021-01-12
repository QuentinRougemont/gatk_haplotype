#!/bin/bash
#SBATCH -J "def-blouis"
#SBATCH --time=00:50:00
#SBATCH --job-name=log_java
#SBATCH --output=ldhat-%J.out
##SBATCH --array=1-33%33
##SBATCH --mem=20G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
##SBATCH --gres=cpu:32

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR
module load picard/2.20.6

input=$1 #a list of variant file to be merged
output=$2 #basename of the output

#creating folder:
OUTFOLDER="10-unplacedVCF" 
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

################## run gatk ########################################
echo "############# Running GATK ###########"

java -jar  $EBROOTPICARD/picard.jar \
  MergeVcfs\
  I=$input \
  O="$OUTFOLDER"/"$output".g.vcf.gz
