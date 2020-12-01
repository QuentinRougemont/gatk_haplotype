#!/bin/bash

#external paramaeters
if [ $# -ne 3 ]; then
        echo "Expecting the following 3 parameters  on the command line, in that order"
        echo "path to the fasta file with its full name "
        echo "Number of intervals to split the fasta file"
        echo "Name of the vcf file (obtained after running CombineGVC )"
else
        #Using values from the command line
        assembly=$1   #"example: 03_genome/GCF_002021735.1_Okis_V1_genomic.fasta" 
        intervals=$2  # expected nb intervals (number of intervals created can be slightly lower or higher)
        bam=$3        #name of the bam one by individual
        echo "assembly=$assembly"
        echo "nb intervals=$intervals"
        echo "bam=$bam"
fi

BAM=$(basename $bam)
DATAFOLDER=$(pwd)
GENOMEFOLDER=${DATAFOLDER}/"03_genome"
GENOME="GCF_002021735.2_Okis_V2_genomic.fna"
REF="$GENOMEFOLDER"/"$GENOME"
INFOLDER="08_cleaned" 
OUTFOLDER="09_haplotype_caller"
mkdir $OUTFOLDER 2>/dev/null
# tmp dir
assemblyname=$(basename $assembly)
mkdir tmp_haplotypcaller_$BAM #_${assemblyname}

# create intervals
python2 ./01_scripts/INTERVALS/script_scaff_length.py $assembly > tmp_haplotypcaller_$BAM/$assemblyname.scaffsize
python2 ./01_scripts/INTERVALS/createintervalsfromscaffsize.py ./tmp_haplotypcaller_$BAM/$assemblyname.scaffsize $intervals
mv scatter*.intervals ./tmp_haplotypcaller_$BAM
cd ./tmp_haplotypcaller_$BAM

for i in scatter*.intervals; do
    echo "#!/bin/bash" > lanceur_interval.$i.sh
    echo "#PBS -A ihv-653-aa" >> lanceur_interval.$i.sh
    echo "#PBS -N gatk #__LIST__" >> lanceur_interval.$i.sh
    echo "#PBS -l walltime=48:00:00" >> lanceur_interval.$i.sh
    echo "#PBS -l nodes=1:ppn=8" >> lanceur_interval.$i.sh
    echo "#PBS -r n" >> lanceur_interval.$i.sh
    echo "# Move to job submission directory" >> lanceur_interval.$i.sh
    echo "cd \$PBS_O_WORKDIR" >> lanceur_interval.$i.sh
    echo "source /clumeq/bin/enable_cc_cvmfs" >> lanceur_interval.$i.sh
    echo "module load gatk/4.1.2.0" >> lanceur_interval.$i.sh
    echo "# Move to job submission directory" >> lanceur_interval.$i.sh
    echo "gatk --java-options "-Xmx8G" HaplotypeCaller -R $REF \\">> lanceur_interval.$i.sh 
    echo "    -I $DATAFOLDER/$INFOLDER/$BAM -ERC GVCF \\" >> lanceur_interval.$i.sh
    echo "    --heterozygosity 0.0015 --indel-heterozygosity 0.001 \\" >> lanceur_interval.$i.sh
    echo "    -O $DATAFOLDER/$OUTFOLDER/"${BAM%.dedup.bam}".$i.g.vcf.gz \\" >> lanceur_interval.$i.sh
    echo "    -L $DATAFOLDER/tmp_haplotypcaller_$BAM/$i \\" >> lanceur_interval.$i.sh 
done
