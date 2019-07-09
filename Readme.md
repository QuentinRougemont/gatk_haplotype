# pipeline for read trimming, mapping, variant calling and filtration from Whole Genome Sequences

# Purpose:

Simple pipeline to call haplotypes from whole genome sequencing data   
Two versions are provided, one with gatk3.8 and the other with gatk4. I provide both because  
the syntax have been changed and there is some additional scripts required with gatk4.

## Dependencies:

**bwa** software avialble [here](https://sourceforge.net/projects/bio-bwa/files/)

**trimmomatic** software available [here](http://www.usadellab.org/cms/?page=trimmomatic)

Alternatively for mapping:  
**fastp** software availalbe [here](https://github.com/OpenGene/fastp)  

**gatk** software available [here](https://software.broadinstitute.org/gatk/)

**picard** tools avaible [here](https://broadinstitute.github.io/picard/)

**Samtools** software available [here](http://www.htslib.org/)

all software should be linked into your bashrc or in your bin, they are all open source

## To do:

**FILL THIS README**  

**MAJOR STEPS:** 

 * 1 trimm the data (trimmomatic or fastp)  
 * 2 align, clean sort, index (bwa, samtools)
 * 3 remove duplicated (picard)
 * 4 created dict (samtools, java)
 * 5 realign indels (gatk)
 * 6 (Recalibrate Base Quality Score from a reference set or using same data with very stringent filtering)
 * 7 Generate GVCF (run haplotype caller)
 * 8 Genotype all individuals
 * 9 Selects SNPs/Indels/
 * 10 Filters variants (quality, depth, etc) 


 * **WARNING** : the script for indel realignment is no longer necessary when running HaplotypeCaller  
	However it is still required if running UnifiedGenotyper  

 * **WARNING** I haven't implemented the BQSR pipeline, given that we don't have reference data.
	Might try with the same data [see](https://software.broadinstitute.org/gatk/documentation/article?id=44)  

 
**Some details:** 

To FILL

 * _1 Trimming_
	* Use either **trimmomatic** (`01-scripts/01_trimmomatic.sh` or **fastp** (`01-scripts/01_fastp.sh` )

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

