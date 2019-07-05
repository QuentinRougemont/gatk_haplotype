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
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

#Global variables
file=14-indel_GVCF/GVCFall_INDEL.vcf.gz #~$1 #name of the bam file 
if [ -z "$file" ]
then
    echo "Error: need vcf "
    exit
fi

name=$(basename $file)

OUTFOLDER="15-indel_filter"
if [ ! -d "OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi
ROAD=$(pwd)
REF="${ROAD}/03_genome/GCF_002021735.1_Okis_V1_genomic.fasta" 
ROAD="/home/qurou/14.epic4/10.WGS/02.align_outgroup/wgs_sample_preparation_coho"
################## run gatk ########################################
#gatk --java-options "-Xmx57G" \
gatk --java-options "-Xmx57G" \
 	 VariantFiltration \
	-R "$REF" \
	-O "$OUTFOLDER"/"${name%.vcf.gz}".filter.vcf.gz \
	-V "$ROAD"/"$file" \
	--filter-expression "QUAL < 0 || MQ < 30.00 || SOR > 10.000 || QD < 2.00 || FS > 200.000 || ReadPosRankSum < -20.000 || ReadPosRankSum > 20.000" \
	--filter-name "snp_filtration" 
