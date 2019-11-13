#!/bin/bash
#PBS -A ihv-653-aa
#PBS -N merge__
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=8
#PBS -r n

# Move to job submission directory
cd $PBS_O_WORKDIR

source /clumeq/bin/enable_cc_cvmfs
module load gatk/4.1.2.0
module load picard/2.20.6

#for i in $(cat list_pop) ; do 
#for j in $(seq 4) ; do  
#echo 12-genoGVCF_2/scatter"$j".intervals."$i"_joint_bwa_mem_mdup_raw.vcf.gz >> 14-list_variants_files/$i.variant_files.list ; 
#done ;done 

pop=$1 #name of the population

DATAFOLDER="/rap/ihv-653-ab/quentin/gatkepic4/"
REF="$GENOMEFOLDER"/"$GENOME"
LISTFOLDER="14-list_variants_files" 
OUTFOLDER="15-pop_vcf"

java -jar $EBROOTPICARD/picard.jar \
    MergeVcfs \
    I="$DATAFOLDER"/"$LISTFOLDER"/${pop}.variant_files.list \
    O="$DATAFOLDER"/"$OUTFOLDER"/${pop}.vcf.gz 
