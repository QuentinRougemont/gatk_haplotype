#!/bin/bash


id=$[ $1  ]
intervals=chr_"$id".intervals 
echo "id is : $id"

FILE_PATH=$(pwd)

rm -rf database."$intervals" 2>/dev/null

gatk --java-options "-Xmx20g -Xms20g" \
      GenomicsDBImport \
      --batch-size 80 \
      --genomicsdb-workspace-path database."$intervals" \
      --tmp-dir ${SLURM_TMPDIR} \
      -L "$FILE_PATH"/INTERVAL/$intervals \
      --sample-name-map MAP/sample_map."$id" \
      --reader-threads 10 
