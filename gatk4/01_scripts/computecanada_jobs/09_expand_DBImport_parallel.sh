#!/bin/bash

#set the array size according to the number of intervals!

listintervals=$1 #interval list (here one id per chromosome but this can be any sort of intervals matchin gatk requirements ) 

echo "runnung genomics_DB_import in parallel for $listintervals"

wanted=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $listintervals )

./01_scripts/expandDBimport.sh  $wanted   
