#!/bin/bash

#########################################################
#last update: 28-05-2019
#SCRIPT TO RUN GATK GVCF from gatkvR38 in GVCF mode
#INPUT: 1.g.vcf file per individual
#INPUT: fasta file (reference genome)
#OUTPUT : 1.g.vcf file with all individuals
########################################################

#load module (on beluga only)
#module load java
#module load gatk/4.1.0.0
#in terminal: create a list of GVCF to copy in the gatk command:
#for i in $(ls 09-gatk_GVCF/*gz ) ; do echo -e "\t -V" $i \\ ; done  > list.g.vcf

#Global variables
OUTFOLDER="10-CombineGVCF" 
if [ ! -d "$OUTFOLDER" ]
then 
    echo "creating out-dir"
    mkdir "$OUTFOLDER"
fi

#file_path="/home/quentin/scratch/10.GATK/coho"
file_path="${pwd}"

#PATH TO ref genome:
REF="$file_path"/02_genome/GCF_002021735.1_Okis_V1_genomic.fasta
if [ -z $REF ];
then
    echo "error please provide reference fasta"
    exit
fi

################## run gatk ########################################
echo "#####"
echo "Running GenotypeGVCFs over all files "
echo "######"
java -Xmx16g -jar /home/qurou/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar \
  	 -T GenotypeGVCFs \
         -R "$REF" \
	 -V 09-gatk_GVCF/HI.3087.007.Index_9.IC-A-2013_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3087.008.Index_8.IC-B-2013_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3134.003.Index_10.IC-1-2013_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3134.004.Index_11.IC-2-2013_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3134.005.Index_20.IC-3-2013_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3134.006.Index_22.Pa-1-2007_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3134.007.Index_25.Pa-2-2007_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3134.008.Index_21.Pa-3-2007_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3431.006.Index_3.Klamath_1_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3431.007.Index_9.Klamath_2_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3431.008.Index_8.Klamath_3_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3432.001.Index_10.Klamath_4_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3432.002.Index_11.Klamath_6_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3432.003.Index_22.Berners_River_9_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3432.004.Index_25.Berners_River_10_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3432.005.Index_21.Berners_River_12_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3432.006.Index_23.Berners_River_13_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3432.007.Index_27.Kwethluk_River_1_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3432.008.Index_2.Kwethluk_River_2_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3433.001.Index_13.Kwethluk_River_4_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3433.002.Index_6.Kwethluk_River_5_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3433.003.Index_15.Kwethluk_River_6_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3433.004.Index_7.Quilcene_River_2_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3433.005.Index_18.Quilcene_River_3_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3433.006.Index_14.Quilcene_River_5_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3433.007.Index_16.Quilcene_River_6_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3433.008.Index_4.Quilcene_River_8_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3434.001.Index_5.Tsoo_Yess_River_1_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3434.002.Index_12.Tsoo_Yess_River_2_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3434.003.Index_19.Tsoo_Yess_River_4_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3434.004.Index_1.Tsoo_Yess_River_5_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3434.005.Index_3.Tsoo_Yess_River_7_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3434.006.Index_9.Deschutes_River_1_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3434.007.Index_8.Deschutes_River_2_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3434.008.Index_10.Deschutes_River_4_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3441.001.Index_5.Capilano_River_5_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3441.002.Index_12.Pallant_Creek_4_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3441.003.Index_19.Pallant_Creek_6_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3441.004.Index_20.Berners_River_6_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3443.001.Index_11.Deschutes_River_5_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3443.002.Index_20.Deschutes_River_7_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3443.004.Index_25.Salmon_River_2_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3443.005.Index_21.Salmon_River_3_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3443.006.Index_23.Salmon_River_4_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3443.007.Index_27.Salmon_River_6_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3443.008.Index_2.Robertson_Creek_1_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3444.001.Index_13.Robertson_Creek_2_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3444.002.Index_6.Robertson_Creek_3_1.g.vcf.gz \
         -V 09-gatk_GVCF/HI.3444.003.Index_15.Robertson_Creek_4_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3444.004.Index_7.Robertson_Creek_5_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3444.005.Index_18.Capilano_River_1_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3444.006.Index_14.Capilano_River_2_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3444.007.Index_16.Capilano_River_3_1.g.vcf.gz \
	 -V 09-gatk_GVCF/HI.3444.008.Index_4.Capilano_River_4_1.g.vcf.gz \
	 -allSites \
	 -hets 0.0015 \
	 -indelHeterozygosity 0.001 \
	 -stand_call_conf 30.0 \
	 -o "$file_path"/"$OUTFOLDER"/combinedGVCF.vcf.gz #\
