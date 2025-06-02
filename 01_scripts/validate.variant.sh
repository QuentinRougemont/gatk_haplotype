#!/bin/bash                        
#PBS -A ihv-653-aa                 
#PBS -N merge__                    
#PBS -l walltime=48:00:00          
#PBS -l nodes=1:ppn=8              
#PBS -r n                          
# Move to job submission directory 
cd $PBS_O_WORKDIR                  


FILE_PATH=$(pwd)
REF="$FILE_PATH/03_genome/yourgenome"

INPUT=$1 #gvcf from HaplotypeCaller

 gatk ValidateVariants \
   -R "$REF" \
   -V "$INPUT" \
   --validation-type-to-exclude ALL

