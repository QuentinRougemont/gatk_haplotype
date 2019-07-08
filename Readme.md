# Quick and dirty pipeline for haplotype calling with Gatk.

# Purpose:

simple pipeline to call haplotypes from whole genome sequencing data

## Dependencies:

**bwa** software avialble [here](https://sourceforge.net/projects/bio-bwa/files/)

**trimmomatic** software available [here](http://www.usadellab.org/cms/?page=trimmomatic)

**gatk** software available [here](https://software.broadinstitute.org/gatk/)

**picard** tools avaible [here](https://broadinstitute.github.io/picard/)

**Samtools** software available [here](http://www.htslib.org/)

all three software should be linked into your bashrc or in your bin

## To do:

**FILL THIS README**

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


Some details:
To FILL
