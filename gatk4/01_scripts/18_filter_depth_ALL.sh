#!/bin/bash
#SBATCH -J "DP_filtration"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p medium
##ATCH -A large
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=05-00:00
#SBATCH --mem=10G

# Move to directory where job was submitted
#cd $SLURM_SUBMIT_DIR

#########################################################
#AUTOHR: Q. Rougemont
#Last UPDATE: 10-05-2019
#Purpose: Script to filter on depth
#INPUT: 1 vcf file
#OUTPUT : 1 vcf file with lowdepth flagged
########################################################

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_FOLDER="99-log_files"
SCRIPT=$0
NAME=$(basename $0)

#Global variables
file=$1 #name of the vcf file 
if [ -z "$file" ]
then
    echo "Error: need clean vcf file"
    exit
fi

name=$(basename $file)

OUTFOLDER="17-wgs_filter_DP"
if [ ! -d "$OUTFOLDER" ]
then
    mkdir "$OUTFOLDER"
fi

#path to the local dir
FILE_PATH=$(pwd)

################## run gatk ########################################
gatk --java-options "-Xmx57G" \
    VariantFiltration \
    -O "$OUTFOLDER"/"${name%.vcf.gz}".filterDP.vcf.gz \
    -V "$FILE_PATH"/"$file" \
    --genotype-filter-expression "DP < 10 || DP > 100" \
    --genotype-filter-name "DP-10-100"

                                                                                               
echo "computing depth is done"                                                                 
echo "compressing $file.table_depth now"                                                       
gzip "${file%.vcf.gz}".table_depth                                                             
                                                                                               
################## Reshape data #####################################                          
                                                                                               
echo "preparing the data for R plot"                                                           
                                                                                               
nb_ind=55 #total number of individuals sequenced                                               
                                                                                               
zcat "${file%.vcf.gz}".table_dept.gz  | \                                                      
    awk '{for(i=4;i<=NF;i+=2) printf("%s%s",$i,(i!=NF)?OFS:ORS)}' > DPind                      
                                                                                               
for i in $(seq $nb_ind ) ; do                                                                  
    cut -f $i DPind  > $i.DP ;                                                                 
done                                                                                           
                                                                                               
for i in *.DP ; do                                                                             
    var=$(head -n 1  $i ) ;                                                                    
    sed "s/^/$var /g" $i |sed  1d >> $i.2 ;                                                    
done                                                                                           
                                                                                               
cat *.DP.2 | gzip >> ALL_DEPTH.gz                                                              
rm *.DP.2                                                                                      
                                                                                               
#here run Rscript                                                                              

