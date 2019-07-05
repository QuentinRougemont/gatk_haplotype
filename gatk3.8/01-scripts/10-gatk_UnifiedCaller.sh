#!/bin/bash
#SBATCH -J "chinnok-all-site_ind3"
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
#last update: 10-10-2018
#SCRIPT TO RUN HaplotypeCaller from gatkv4.0.9 in GVCF mode
#INPUT: 1 bam file per individual
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file per individual
########################################################

#Global variables
file=$1 #name of the bam file 
if [ -z "$file" ]
then
    echo "Error: need bam name (eg: sample1.bam)"
    exit
fi

name=$(basename $file)
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="99-log_files"
SCRIPT=$0
NAME=$(basename $0)
#cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

OUTFOLDER="10-gatk_vcf" 
if [ ! -d "OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

REF="/home/qurou/14.epic4/10.WGS/01.align_outgroup/wgs_sample_preparation_rainbow_trout/03_genome/okis.genome.allpaths_v52488.2PE_30X_3MP_10X_15X_15X.pbjelly_all_pacbio.scaffolds_500bp.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi
GATK="/home/qurou/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar"

################## run gatk ########################################
java -jar "$GATK" \
	-T UnifiedGenotyper \
        -R "$REF" \
        -I "$file" \
	-o "$OUTFOLDER"/"$name".vcf.gz \
        --genotyping_mode DISCOVERY \
        --output_mode EMIT_ALL_SITES #\
        #--min_base_quality_score 10 \
        #-stand_call_conf 30 
##################################################################
#gatk --java-options "-Xmx57G" \
#	SelectVariants \
#	-R "$REF" \	
#	-V "$OUTFOLDER"/"$name".vcf \
#	-selectType SNP
#	-o "OUTFOLDER"/"$name".snp.vcf
#exit
#gatk --java-options "-Xmx57G" \
#	VariantFiltration \
#	-R "$REF" \
#	-V "OUTFOLDER"/"$name".snp.vcf
#	--filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
#	--filterName "my_snp_filter" \
#	-o "$OUTFOLDER"/"$name".filter.snps.vcf
	
#echo -e "$id" > 10-log_files/log."id"
#id=$(echo $id + 1 | bc)
