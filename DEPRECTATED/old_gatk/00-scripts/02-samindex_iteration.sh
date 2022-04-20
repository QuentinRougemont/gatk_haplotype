#!/bin/bash

# Global variables
id=$[ $1 - 1 ]
files=(04-bam_files_fixed/*.bam)
file=${files[$id]}

samtools index "$file"
