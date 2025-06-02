#!/bin/bash

#external paramaeters
if [ $# -ne 3 ]; then
        echo "Expecting the following 3 parameters  on the command line, in that order"
        echo "path to the fasta file with its full name "
        echo "Number of intervals to split the fasta file"
        echo "Name of the vcf file (obtained after running CombineGVC )"
else
        #Using values from the command line
        assembly=$1   #"03_genome/GCF_002021735.1_Okis_V1_genomic.fasta" #$1  # genome assembly
        intervals=$2  # expected nb intervals (number of intervals created can be slightly lower or higher)
        vcf=$3        #name of the vcf #one vcf by pop
        echo "assembly=$assembly"
        echo "nb intervals=$intervals"
        echo "vcf=$vcf"
fi

VCF=$(basename $vcf)
pop=${VCF%.combinedGVCF.vcf.gz}
#exit
#GLOBAL VARIABLE FOR WRITING THE SCRIPT
DATAFOLDER=$(pwd)

GENOMEFOLDER=${DATAFOLDER}/"03_genome"
GENOME="genome.fasta"
REF="$GENOMEFOLDER"/"$GENOME"
INFOLDER="11-CombineGVCF" 
OUTFOLDER="12-genoGVCF_2"
mkdir $OUTFOLDER 2>/dev/null

# tmp dir
assemblyname=$(basename $assembly)
mkdir tmp_vcf_${pop}_${assemblyname}

# create intervals
#script python from Thibault Leroy
python ./01_scripts/katak_scripts/INTERVALS/script_scaff_length.py $assembly > ./tmp_vcf_${pop}_${assemblyname}/$assemblyname.scaffsize
python ./01_scripts/katak_scripts/INTERVALS/createintervalsfromscaffsize.py ./tmp_vcf_${pop}_${assemblyname}/$assemblyname.scaffsize $intervals
mv scatter*.intervals ./tmp_vcf_${pop}_${assemblyname}/
cd ./tmp_vcf_${pop}_${assemblyname}/

for i in scatter*.intervals; do
    echo "#!/bin/bash" > lanceur_interval.$i.sh
    echo "#SBATCH -J \"GenotypeIntervals\"" >> lanceur_interval.$i.sh
    echo "#SBATCH -o log_%j" >> lanceur_interval.$i.sh
    echo "#SBATCH -c 1" >> lanceur_interval.$i.sh
    echo "#SBATCH -p medium" >> lanceur_interval.$i.sh
    echo "#SBATCH --time=02-00:00" >> lanceur_interval.$i.sh
    echo "SBATCH --mem=10G">> lanceur_interval.$i.sh
    echo "# Move to job submission directory" >> lanceur_interval.$i.sh
    echo "cd \$SLURM_SUBMIT_DIR" >> lanceur_interval.$i.sh
    echo "gatk --java-options "-Xmx7G" GenotypeGVCFs -R $REF \\">> lanceur_interval.$i.sh 
    echo "    -O $DATAFOLDER/$OUTFOLDER/$i.${pop}_joint_bwa_mem_mdup_raw.vcf.gz \\" >> lanceur_interval.$i.sh
    echo "    -V $DATAFOLDER/$INFOLDER/$VCF \\">> lanceur_interval.$i.sh 
    echo "    -L $DATAFOLDER/tmp_vcf_${pop}_${assemblyname}/$i --all-sites true --heterozygosity 0.0015\\" >> lanceur_interval.$i.sh 
done
