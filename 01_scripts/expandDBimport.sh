#!/bin/bash


id=$[ $1  ]
intervals=chr_"$id".intervals 
echo "id is : $id"

FILE_PATH=$(pwd)

gatk --java-options "-Xmx20g -Xms20g" \
      GenomicsDBImport \
      --batch-size 80 \
      --genomicsdb-update-workspace-path "$FILE_PATH"/11-database/INGROUP/database/database."$intervals" \
      --tmp-dir tmp \
      --sample-name-map MAP_ADDITIONAL_SAMPLE/sample_map."$id" \
      --reader-threads 10 

