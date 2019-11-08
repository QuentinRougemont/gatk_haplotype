#!/bin/bash

# Create list of samples
ls 04.raw/*f*q.gz | split -l 3 - temp.list.

#change directory in gsnap template job
i=$(pwd)
sed "s#__PWD__#$i#g" 01_scripts/colosse_jobs/samtools_template.sh > 01_scripts/colosse_jobs/samtools.sh

# Create list of jobs
for base in $(ls temp.list.*)
do
    toEval="cat 01_scripts/colosse_jobs/samtools.sh | sed 's/__LIST__/$base/g'"
    eval $toEval > 01_scripts/colosse_jobs/samtools_$base.sh
done

# Submit jobs
for i in $(ls 01_scripts/colosse_jobs/samtools_*.sh)
do
    msub $i
done
