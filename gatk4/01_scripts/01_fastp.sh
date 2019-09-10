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

# trim input files in 04_raw_data with fastp

# Iterate over files in data folder
for file in $(ls -1 04_raw_data/*_R1.fastq.gz)
do
    input_file=$(echo "$file" | perl -pe 's/_R1.fastq.gz//')
    output_file=$(basename "$input_file")
    echo "Treating: $output_file"

    fastp -w 6 \
        -i "$input_file"_R1.fastq.gz \
        -I "$input_file"_R2.fastq.gz \
        -o 05_trimmed/"$output_file"_1.trimmed.fastq.gz \
        -O 05_trimmed/"$output_file"_2.trimmed.fastq.gz \
        -j 05_trimmed/01_reports/"$output_file".json \
        -h 05_trimmed/01_reports/"$output_file".html
done
