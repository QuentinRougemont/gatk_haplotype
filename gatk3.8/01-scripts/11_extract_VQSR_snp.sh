#!/bin/bash
#SBATCH -J "coho"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06-00:00
#SBATCH --mem=08G
# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#########################################################
#last update: 28-05-2019
#SCRIPT TO extract VQSR from vcf file with gatk3.8
#INPUT: 1 vcf file
#INPUT: fasta file (reference genome)
#OUTPUT : table of quality score
########################################################
#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#Global variables
OUTFOLDER="11-snp_GVCF"
#file_path="/home/quentin/scratch/10.GATK/coho"
file_path="${pwd}"

#PATH TO ref genome:
REF="$file_path/02_genome/GCF_002021735.1_Okis_V1_genomic.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi
################## run gatk ########################################
echo "#####"
echo "extract qulaity scores"
echo "######"
java -Xmx16g -jar /home/qurou/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
	-T VariantsToTable \
        -R "${REF}" \
	-V "${OUTFOLDER}"/GVCFall_SNPs.vcf.gz \
	-F CHROM -F POS -F QUAL -F QD -F DP -F MQ -F MQRankSum -F FS -F ReadPosRankSum -F SOR \
	--allowMissingData \
	-O "${file_path}"/"${OUTFOLDER}"/GVCFall_SNPs.table \

