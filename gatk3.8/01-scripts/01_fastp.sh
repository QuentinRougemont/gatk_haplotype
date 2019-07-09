#!/bin/bash
#SBATCH -J "fastp_chinook"
#SBATCH -o log_%j
#SBATCH -c 6
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=05-00:00
#SBATCH --mem=10G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#create outputput dir if not present
if [ ! -d "04_trimmed" ]
then
	mkdir 04_trimmed
fi

#on fastq by subfolder "file1" and runs all in parallel
for file in $(ls -1 04_raw_data/file1/*_R1.fastq.gz)
do
    input_file=$(echo "$file" | perl -pe 's/_R1.fastq.gz//')
    output_file=$(basename "$input_file")
    echo "Treating: $output_file"

    fastp -w 6 \
	-l=100 \
	-q=25 \
	-c \
        -i "$input_file"_R1.fastq.gz \
        -I "$input_file"_R2.fastq.gz \
        -o 04_trimmed/"$output_file"_1.trimmed.fastq.gz \
        -O 04_trimmed/"$output_file"_2.trimmed.fastq.gz \
        -j 04_trimmed/01_reports/"$output_file".json \
        -h 04_trimmed/01_reports/"$output_file".html
done
