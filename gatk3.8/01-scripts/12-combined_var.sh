#!/bin/bash
#SBATCH -J "combvar_coho_capil"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p large
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=8-00:00
#SBATCH --mem=16G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#########################################################
#last update: 10-10-2018
#SCRIPT TO RUN HaplotypeCaller from gatkv4.0.9 in GVCF mode
#INPUT: 1 bam file per individual
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file per individual
########################################################
file1=$1
file2=$2
file3=$3
file4=$4
file5=$5
out=$6
#Global variableouts
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="99-log_files"

OUTFOLDER="11-gatk_combvcf"
if [ ! -d "OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

ROAD=$(pwd)
GATK="/home/qurou/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar"
REF="${ROAD}/03_genome/GCF_002021735.1_Okis_V1_genomic.fasta" 

#echo $file
################## run gatk ########################################
java -jar "$GATK" \
	-T CombineVariants \
        -R "$REF" \
        --variant "$ROAD"/"$file1" \
        --variant "$ROAD"/"$file2" \
        --variant "$ROAD"/"$file3" \
        --variant "$ROAD"/"$file4" \
        --variant "$ROAD"/"$file5" \
	-o "$ROAD"/"$OUTFOLDER"/"$out".vcf.gz \
        -genotypeMergeOptions UNIQUIFY
##################################################################
