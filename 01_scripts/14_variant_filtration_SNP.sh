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
#cd $SLURM_SUBMIT_DIR
#########################################################
#AUTHOR: Q. Rougemont
#DATE: June 2019
#Purpose: Script to filter SNPs
########################################################
#Global variables
file=$1 #13-snp_GVCF/GVCFall_SNPs.vcf.gz #~$1 #name of the bam file 
if [ -z "$file" ]
then
    echo "Error: need vcf "
    exit
fi

name=$(basename $file)

OUTFOLDER="15-snp_filter"
if [ ! -d "OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi
FILE_PATH=$(pwd)
################## run gatk ########################################
echo "keep good quality SNPs now"
echo "input file is $file "                                         
echo "output file will be "${name%.vcf.gz}".filter3.vcf.gz"         

gatk --java-options "-Xmx57G" \
    VariantFiltration \
    -O "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz \
    -V "$FILE_PATH"/"$file" \
    --filter-name "FAILED_QUAL" --filter-expression "QUAL < 0" \
    --filter-name "FAILED_SOR"  --filter-expression "SOR > 4.000"\
    --filter-name "FAILED_MQ"   --filter-expression "MQ < 30.00" \
    --filter-name "FAILED_QD"   --filter-expression "QD < 2.00" \
    --filter-name "FAILED_FS"   --filter-expression "FS > 60.000" \
    --filter-name "FAILED_MQRS" --filter-expression "MQRankSum < -20.000" \
    --filter-name "FAILED_RPR"  --filter-expression "ReadPosRankSum < -10.000 || ReadPosRankSum > 10.000"

#### Extract good SNP passing filters ###### 
zcat "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz | grep -E '^#|PASS' |grep -v "FAILED" > $OUTFOLDER/"${name%.vcf.gz}".final.vcf
bgzip "$OUTFOLDER"/"${name%.vcf.gz}".final.vcf
tabix -p vcf "$OUTFOLDER"/"${name%.vcf.gz}".final.vcf.gz
bcftools index "$OUTFOLDER"/"${name%.vcf.gz}".final.vcf.gz

zcat "$OUTFOLDER"/"${name%.vcf.gz}".final.vcf.gz | sed '/*/d'  > "$OUTFOLDER"/"${name%.vcf.gz}".final_cleaned.vcf 
bgzip "$OUTFOLDER"/"${name%.vcf.gz}".final_cleaned.vcf 
tabix -p vcf "$OUTFOLDER"/"${name%.vcf.gz}".final_cleaned.vcf.gz 
bcftools index "$OUTFOLDER"/"${name%.vcf.gz}".final_cleaned.vcf.gz 
