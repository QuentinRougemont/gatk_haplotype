#!/bin/bash
#SBATCH -J "filtration"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=07-00:00
#SBATCH --mem=10G
# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR
#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 23-03-2020
#Purpose: Script to filter the complete genome gatkv4.0.9
#INPUT: 1 whole gvcffile
#OUTPUT : 1 whole gvcfile with bad sites flagged.
########################################################
#Global variables
file=11-genoGVCF/GVCFall.vcf.gz #~$1 #name of the bam file 
if [ -z "$file" ]
then
    echo "Error: need vcf "
    exit
fi
name=$(basename $file)

OUTFOLDER="16-wgs_filter"
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

#path to the local dir
FILE_PATH=$(pwd)
#PATH TO ref genome:
REF="$FILE_PATH/03_genome/your_ref_genome.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi
################## run gatk ########################################
echo "############# Running GATK ###########"
echo "filtering whole genome file  $name    "
gatk --java-options "-Xmx10G" \
    VariantFiltration \
    -R "$REF" \
    -O "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz \
    -V "$FILE_PATH"/"$file" \
    --filter-name "FAILED_QUAL" --filter-expression "QUAL < 0" \
    --filter-name "FAILED_SOR"  --filter-expression "SOR > 4.000"\
    --filter-name "FAILED_MQ"   --filter-expression "MQ < 30.00" \
    --filter-name "FAILED_QD"   --filter-expression "QD < 2.00" \
    --filter-name "FAILED_FS"   --filter-expression "FS > 60.000" \
    --filter-name "FAILED_MQRS" --filter-expression "MQRankSum < -20.000" \
    --filter-name "FAILED_RPR"  --filter-expression "ReadPosRankSum < -10.000 || ReadPosRankSum > 10.000"
