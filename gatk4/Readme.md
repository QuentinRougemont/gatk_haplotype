
# GATK4

 * scripts for gatk4.1 do not work with the v3 since the syntax has been changed  
 * One additional step is required that was not present in V3, the scripts `01_scripts/12_CombineGVCF.sh` implements the "CombineGVCF" option not required in the v3  

## PURPOSE: Pipeline For read mapping and SNP calling with GATK 

 * The `03_genome` should contain your reference genome  
 * The `04_raw_data` must contain your raw fastq sequencing data  
 * Other folder will be created when running the pipeline 
 
