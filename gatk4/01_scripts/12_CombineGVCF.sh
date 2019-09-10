#!/bin/bash
#SBATCH -J "job_name"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=06-00:00
#SBATCH --mem=16G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

#########################################################
#last update: 28-05-2019
#SCRIPT TO combine all vcf from gatkv4.0.9 in GVCF mode
#INPUT: all individual vcf files 
#INPUT: fasta file (reference genome)
#OUTPUT : 1 vcf file for all individuals
########################################################

#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0

#in terminal: create a list of GVCF to copy in the gatk command:
#for i in $(ls 10-gatk_GVCF/*gz ) ; do echo -e "\t -V" $i \\ ; done  > list_vcf

#Global variables
OUTFOLDER="11-CombineGVCF" 
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

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
echo "#        combining whole gvcf.gz     #"

gatk --java-options "-Xmx57G" \
    CombineGVCFs \
    -R "$REF" \
    -V 10-gatk_GVCF/HI.3087.007.Index_9.IC-A-2013_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3087.008.Index_8.IC-B-2013_1.vcf.gz \
    -V 10-gatk_GVCF/HI.3134.003.Index_10.IC-1-2013_1.vcf.gz \
    -V 10-gatk_GVCF/HI.3134.004.Index_11.IC-2-2013_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3134.005.Index_20.IC-3-2013_1.vcf.gz \
    -V 10-gatk_GVCF/HI.3134.006.Index_22.Pa-1-2007_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3134.007.Index_25.Pa-2-2007_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3134.008.Index_21.Pa-3-2007_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3431.006.Index_3.Klamath_1_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3431.007.Index_9.Klamath_2_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3431.008.Index_8.Klamath_3_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3432.001.Index_10.Klamath_4_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3432.002.Index_11.Klamath_6_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3432.003.Index_22.Berners_River_9_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3432.004.Index_25.Berners_River_10_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3432.005.Index_21.Berners_River_12_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3432.006.Index_23.Berners_River_13_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3432.007.Index_27.Kwethluk_River_1_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3432.008.Index_2.Kwethluk_River_2_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3433.001.Index_13.Kwethluk_River_4_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3433.002.Index_6.Kwethluk_River_5_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3433.003.Index_15.Kwethluk_River_6_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3433.004.Index_7.Quilcene_River_2_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3433.005.Index_18.Quilcene_River_3_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3433.006.Index_14.Quilcene_River_5_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3433.007.Index_16.Quilcene_River_6_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3433.008.Index_4.Quilcene_River_8_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3434.001.Index_5.Tsoo_Yess_River_1_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3434.002.Index_12.Tsoo_Yess_River_2_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3434.003.Index_19.Tsoo_Yess_River_4_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3434.004.Index_1.Tsoo_Yess_River_5_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3434.005.Index_3.Tsoo_Yess_River_7_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3434.006.Index_9.Deschutes_River_1_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3434.007.Index_8.Deschutes_River_2_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3434.008.Index_10.Deschutes_River_4_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3441.001.Index_5.Capilano_River_5_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3441.002.Index_12.Pallant_Creek_4_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3441.003.Index_19.Pallant_Creek_6_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3441.004.Index_20.Berners_River_6_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3443.001.Index_11.Deschutes_River_5_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3443.002.Index_20.Deschutes_River_7_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3443.004.Index_25.Salmon_River_2_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3443.005.Index_21.Salmon_River_3_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3443.006.Index_23.Salmon_River_4_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3443.007.Index_27.Salmon_River_6_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3443.008.Index_2.Robertson_Creek_1_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3444.001.Index_13.Robertson_Creek_2_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3444.002.Index_6.Robertson_Creek_3_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3444.003.Index_15.Robertson_Creek_4_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3444.004.Index_7.Robertson_Creek_5_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3444.005.Index_18.Capilano_River_1_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3444.006.Index_14.Capilano_River_2_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3444.007.Index_16.Capilano_River_3_1.no_overlap.bam.vcf.gz \
    -V 10-gatk_GVCF/HI.3444.008.Index_4.Capilano_River_4_1.no_overlap.bam.vcf.gz \
    --convert-to-base-pair-resolution \
    -O "$FILE_PATH"/"$OUTFOLDER"/combinedGVCF.vcf.gz \
