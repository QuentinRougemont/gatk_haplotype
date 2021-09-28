
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
          script to use is `01-scripts/01_fastp.sh` 

 * _2 Align_
	* Use **bwa mem**, **samtools** to filter, sort and index :  
          script to use is: `01-scripts/02_bwa_mem_align_reads_PE.sh` 
		default parameters should work.  
		For samtools important parameter is the -q to only include reads with a mapping quality >= INT (20 or 30 is a good value)


 * _3 remove duplicate_
	* Simply use **picard** tools :  
          script to use is: `01-scripts/03_remove_duplicates.sh` 

 * _4 add ReadGroup_  
	* script to use is: `01-scripts/04_add_readgroup.sh` this is usefull to have sample name that will be used in the vcf file from gatk for each sample

 * _6 generate gvcf with HaplotypeCaller, create a database or combine the vcf and  perform the joint genotyping_* 
	* use the different **gatk** scripts from `01-scripts/07_gatk_GVCF.sh` to `01-scripts/15_depth_filter.sh`  

    ***TWO OPTIONS***

    with few CPUs use : 
	* `06_gatk_haplotype_caller_single_GVCF.sh` to generate gvcf file for each individuals   
	* `08_CombineGVCF.sh` to combine all individuals together 
	* `09_genotype_GVCF.sh` genotype vcf to perform the joint genotyping  

    with many CPUs use :
	* parallel to parellize every operation by splitting the genome in intervals (e.g. chromosome)  
	*  For instance on a slurm architecture use the script located in: `computecanada_jobs` to:  
		* generate gvcf with HaplotypeCaller in chunks for each individuals (scripts: `07_gatk_Haplotype_Caller_parallel_arg.sh` )  
		* create the database with genomicDBImport in parallel: scripts `08_DBImport_parallel.sh` OR combine the individuals vcfs with `08_combine_paralle.sh` but slower  
		* perform the joint genotyping for each intervals : 09_genotype_from_DBImport_parallel.sh OR: 09_genotype_from_CombineGVCF_parallel.sh   
      
	* _7 extract SNPs and INDELS_ 
       * Simply use : `01-scripts/11_snp_selection.sh` and `01-scripts/12_indel_selection.sh`
         these have to be filtered based on quality score!

	* _8 filtrer SNPs, Indels and Whole Genome file_  
		* extract VQSR for SNPs and INDELs with `01-scripts/13_extract_VQSR.sh`  
      then plot the scores in R [with this script](https://github.com/QuentinRougemont/gatk_haplotype/blob/master/gatk4/01_scripts/Rscripts/plot_VQSR.R) 
      
      you can obtain this sort of plot: 
      ![example_graph](https://github.com/QuentinRougemont/gatk_haplotype/blob/master/pictures/example.png)  

		* then filter the SNPs, INDELs and WGS file that do not pass the quality metrics using e.g. :  
			* For SNPs: `01_scripts/14_variant_filtration_SNP.sh`  
			* For INDELs: `01_scripts/15_variant_filtration_INDEL.sh`  
			* For WGS: `01_scripts/17_wgs_filtration.sh`  
		* Then it is good to also look at the depth and mark as "no call (./.)" sites that have a too low depth :  
			* extract the depth `16_extract_depth.sh`  
			* plot the depth `01_scripts/Rscripts/plot_depth_gatk.R`  
			* filter `01_scripts/18.filter_depth.sh`
			* set failed site to nocall `01_scripts/19_wgs_to_nocall.sh` 


	In general I call all SNP, indel and invariants and then create separate quality filtered file.   
	It is important for some statistics to keep all data including all invariants or low frequency allele  
	Invariants can then be set to 'N' in some applications   
	Some selection tests will be best performed with minor allele frequency thresholds 

  * _8b faster filtration with bcftools:_ 


