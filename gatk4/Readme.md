
## Dependencies:

**[parallel](https://www.gnu.org/software/parallel/)** 

**bwa** software avialble [here](https://sourceforge.net/projects/bio-bwa/files/)

   note: Also works with [bwa-mem2](https://github.com/bwa-mem2/bwa-mem2) 

**fastp** software availalbe [here](https://github.com/OpenGene/fastp)  

**gatk** software available [here](https://software.broadinstitute.org/gatk/)

**picard** tools avaible [here](https://broadinstitute.github.io/picard/)

**Samtools** software available [here](http://www.htslib.org/)



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

**MAJOR STEPS:** 

 * _1 Trimming_
	* Use **fastp** 
          script to use:
              `01-scripts/01_fastp.sh` 

 * _2 Align_
	* Use **bwa mem**, **samtools** to filter, sort and index (`01-scripts/02_bwa_mem_align_reads_PE.sh`) 

 * _3 remove duplicate_
	* Simply use **picard** tools (`01-scripts/03_rm_dup_and_index_sh` )

 * _5 realign indels_  
	* use `01-scripts/05_realign_indel.sh`

 * _6 generate vcf with haplotype caller_ 
	* use the different **gatk** scripts from `01-scripts/07_gatk_GVCF.sh` to `01-scripts/15_depth_filter.sh`

	In general I call all SNP, indel and invariants and then create separate quality filtered file.   
	It is important for some statistics to keep all data including all invariants or low frequency allele  
	Invariants can then be set to 'N' in some applications   
	Some selection tests will be best performed with minor allele frequency thresholds 

