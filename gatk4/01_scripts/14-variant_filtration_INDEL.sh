#!/bin/bash
#SBATCH -J "variantfiltration"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p large
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=08-00:00
#SBATCH --mem=30G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR
#########################################################
#AUTHOR: Q. Rougemont
#DATE: June 2019
#Purpose: Script to filter indel
########################################################
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="99-log_files"
SCRIPT=$0
NAME=$(basename $0)
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

#Global variables
file=14-indel_GVCF/GVCFall_INDEL.vcf.gz #~$1 #name of the vcf indel file 
if [ -z "$file" ]
then
    echo "Error: need vcf file"
    exit
fi

name=$(basename $file)

OUTFOLDER="15-indel_filter"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi
FILE_PATH=$(pwd)
REF="$FILE_PATH/03_genome/your_ref_genome.fasta" 
################## run gatk ########################################
echo "keep good quality indel now"

gatk --java-options "-Xmx57G" \
    VariantFiltration \
    -R "$REF" \
    -O "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz \
    -V "$FILE_PATH"/"$file" \
    --filter-expression "QUAL < 0 || MQ < 30.00 || SOR > 10.000 || QD < 2.00 || FS > 200.000 || ReadPosRankSum < -20.000 || ReadPosRankSum > 20.000" \
    --filter-name "indel_filtration" 

zcat "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz |grep  -E '^#|PASS' > "$OUTFOLDER"/${names%.vcf.gz}.INDEL.vcf 

bgzip "$OUTFOLDER"/${names%.vcf.gz}.INDEL.vcf 
tabix -p vcf "$OUTFOLDER"/${names%.vcf.gz}.INDEL.vcf.gz
bcftools index  "$OUTFOLDER"/${names%.vcf.gz}.INDEL.vcf.gz
