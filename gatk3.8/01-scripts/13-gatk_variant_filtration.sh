#!/bin/bash
#SBATCH -J "big_filtration"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p large
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=08-00:00
#SBATCH --mem=30G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#########################################################
########################################################
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="99-log_files"
SCRIPT=$0
NAME=$(basename $0)

#Global variables
file=$1 #name of the bam file 
if [ -z "$file" ]
then
    echo "Error: need bam name (eg: sample1.bam)"
    exit
fi

name=$(basename $file)

INFOLDER="12-gatk_allpop"
OUTFOLDER="12-gatk_filter"
if [ ! -d "OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi
ROAD=$(pwd)
REF="${ROAD}/03_genome/GCF_002021735.1_Okis_V1_genomic.fasta" 
GATK="/home/qurou/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar"
################## run gatk ########################################
java -jar "$GATK" \
 	-T VariantFiltration \
	-R "$REF" \
	-o "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz \
	--variant "$ROAD"/"$file" \
	--filterExpression "QD < 2.00 || FS > 60.00 || MQ < 40.0 || MQRankSum < -15.000 || ReadPosRankSum < -10.000 || ReadPosRankSum > 10.000" \
	--filterName "test" 
	
