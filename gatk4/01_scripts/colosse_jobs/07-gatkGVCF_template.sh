#!/bin/bash
#PBS -A ihv-653-aa
#PBS -N gatk__LIST__
#PBS -o gatk__LIST__.out
#PBS -e gatk__LIST__.err
#PBS -l walltime=20:00:00
#PBS -M YOUREMAIL
####PBS -m ea
#PBS -l nodes=1:ppn=8
#PBS -r n

# Global variables
list=__LIST__

# Move to job submission directory
cd $PBS_O_WORKDIR

# Load gmap module
source /clumeq/bin/enable_cc_cvmfs
#module load samtools/1.5
#module load bwa/0.7.15
module load gatk/4.1.2.0

# Global variables
DATAFOLDER="04_raw"
GENOMEFOLDER="/rap/ihv-653-ab/quentin/gatkepic4/03_genome/"
GENOME="GCF_002021735.1_Okis_V1_genomic.fasta"
OUTFOLDER="10-gatk_GVCF" 
REF="$GENOMEFOLDER"/"$GENOME" 

for file in $(cat $list)
do
	name=$(basename $file)
	echo "############# Running GATK ###########"
	echo "Running haplotypcaller for file $name "

	gatk --java-options "-Xmx7G" \
    	HaplotypeCaller \
    	-R "$REF" \
    	--native-pair-hmm-threads 8\
    	-I "$file" \
    	-ERC GVCF \
    	--heterozygosity 0.0015 \
    	-O "$OUTFOLDER"/"${name%.bam}".g.vcf.gz 
done
