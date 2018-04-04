#!/bin/bash
#SBATCH -J "epic"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p ibismax
#SBATCH -A ibismax
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=58:30:00
#SBATCH --mem=58G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR
module load vcftools


TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="10-log_files"

# Global variables
fasta_file="/home/qurou/14.epic4/10.WGS/gatk_workflow/02-genome/okis.genome.allpaths_v52488.2PE_30X_3MP_10X_15X_15X.pbjelly_all_pacbio.scaffolds_500bp.fasta"

output_variants="04-results/raw_variants.vcf"
output_snp="04-results/raw_snps.vcf"
#GATK_JAR="/home/qurou/software/gatk-4.0.3/GenomeAnalysisTK.jar"
#tmp="/home1/scratch/jleluyer/"

# Create list bam input files
ls -1 03-bam_files/*.sorted.bam >01-info_files/input.bamfiles.list

input_file="01-info_files/input.bamfiles.list"
gatk --java-options "-Xmx57G" \
	HaplotypeCaller \
        -R "$fasta_file" \
        -I "$input_file" \
        --min_base_quality_score 10 \
        --genotyping_mode DISCOVERY \
        -stand_emit_conf 10 \
        -stand_call_conf 30 \
        --output $output_variants 2>"$LOG_FOLDER"/"$TIMESTAMP".haplotypecaller.log
exit
java -jar $GATK_JAR \
    -T SelectVariants \
    -R $reference_fa \
    -V $output_variants \
    -selectType SNP \
    -o $output_snp 2>"$LOG_FOLDER"/"$TIMESTAMP".selectvariant.log
