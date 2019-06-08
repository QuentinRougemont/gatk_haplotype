#!/bin/bash
#SBATCH -J "gatk"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p large
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=20-00:00
#SBATCH --mem=28G

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
LOG_FOLDER="10-log_files"
SCRIPT=$0
NAME=$(basename $0)
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

OUTFOLDER="05-results_gatk_gvcf_best_practices" 
if [ ! -d "OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

REF="02-genome/okis.genome.allpaths_v52488.2PE_30X_3MP_10X_15X_15X.pbjelly_all_pacbio.scaffolds_500bp.fasta"
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi

#echo $file
################## run gatk ########################################
gatk --java-options "-Xmx57G" \
        HaplotypeCaller  \
        -R "$REF" \
        -I "$file" \
	-O "$OUTFOLDER"/"$name".vcf.gz \
        --genotyping-mode DISCOVERY \
	-ERC GVCF \
        --min-base-quality-score 10 \
        -stand-call-conf 30 
	 2>"$LOG_FOLDER"/"$TIMESTAMP"."$name".haplotypecaller.log
        #--output-mode EMIT_ALL_SITES \
##################################################################
#gatk --java-options "-Xmx57G" \
#	SelectVariants \
#	-R "$REF" \	
#	-V "$OUTFOLDER"/"$name".vcf \
#	-selectType SNP
#	-o "OUTFOLDER"/"$name".snp.vcf
exit
#gatk --java-options "-Xmx57G" \
#	VariantFiltration \
#	-R "$REF" \
#	-V "OUTFOLDER"/"$name".snp.vcf
#	--filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
#	--filterName "my_snp_filter" \
#	-o "$OUTFOLDER"/"$name".filter.snps.vcf
	
#echo -e "$id" > 10-log_files/log."id"
#id=$(echo $id + 1 | bc)
