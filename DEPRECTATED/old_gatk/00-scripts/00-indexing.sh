#!/bin/bash


# Global variables
input_file="/home/qurou/14.epic4/10.WGS/gatk_workflow/02-genome/okis.genome.allpaths_v52488.2PE_30X_3MP_10X_15X_15X.pbjelly_all_pacbio.scaffolds_500bp.fasta"
picard="/home/qurou/software/picard_tools/picard.jar"

java -jar "$picard" \
	CreateSequenceDictionary \
	R= "$input_file" \
	O= "${input_file%.fasta}".dict


samtools faidx "$input_file"
