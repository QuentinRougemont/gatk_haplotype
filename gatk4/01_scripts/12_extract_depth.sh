#!/bin/bash
#SBATCH -J "extract_depth"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p small 
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=01-00:00
#SBATCH --mem=04G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

#########################################################
#last update: 28-05-2019
#SCRIPT TO extract DEPTH with gatkv4.0.9
#INPUT: 1 vcf file
#OUTPUT : table of DEPTH
########################################################
#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0
#Global variables
#Global variables
file=$1 #input vcf.gz file  #either SNP, indel or WGS vcf file

if [ -z "$file" ]
then
    echo "Error: need compressed vcf.gz file"
    exit
fi

name=$(basename $file)

#path to the local dir
FILE_PATH=$(pwd)
mkdir DEPTH 2&>>/dev/null
################## run gatk ########################################
gatk --java-options "-Xmx57G" \
    VariantsToTable \
    -V "$file" \
    -F CHROM -F POS -GF GT -GF DP \
    -O DEPTH/"${name%.vcf.gz}".table_depth  

echo "computing depth is done"

################## Reshape data #####################################    
cd DEPTH
echo "preparing the data for R plot"
awk '{for(i=4;i<=NF;i+=2)
     printf("%s%s",$i,(i!=NF)?OFS:ORS)}' "${name%.vcf.gz}".table_depth > DPind."$name"

echo "compressing $name.table_depth now"
gzip DPind."$name"
gzip "${name%.vcf.gz}".table_depth
