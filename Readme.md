# Quick and dirty pipeline for haplotype calling with Gatk.

# Purpose:

simple pipeline to call haplotypes from whole genome sequencing data

## Dependencies:

**gatk** software available [here](https://software.broadinstitute.org/gatk/)

**picard** tools avaible [here](https://broadinstitute.github.io/picard/)

**Samtools** software available [here](http://www.htslib.org/)

all three software should be linked into your bashrc or in your bin

## To do:

** FILL THIS README **

Some details:

first check if your bam(s) are consistent for use with gatk. If not they 
might need to have a read group and to be indexed. See the first and 
second scripts in `00-scripts/` 
Then you should be able to run gatk.
