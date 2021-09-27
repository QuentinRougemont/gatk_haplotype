
# GATK4

 * scripts for gatk. tested on v4.1.0 v4.1.2.0 v4.1.9.0 and v4.2.2.0 do not work with the v3 since the syntax has been changed  
 * One additional step is required that was not present in V3, the scripts `01_scripts/12_CombineGVCF.sh` implements the "CombineGVCF" option not required in the v3 
 * Alternatively to CombineGVCF you can use genomicDBImport which is really faster 

## PURPOSE: Pipeline For read mapping and SNP calling with GATK 

 * The `03_genome` should contain your reference genome  
 * The `04_raw_data` must contain your raw fastq sequencing data  
 * Other folder will be created when running the pipeline 

 *  Different approaches are implemented either using single thread or in parallel by chromosomes
 *  In general using genomicDBImport seems faster than combineGVCF
