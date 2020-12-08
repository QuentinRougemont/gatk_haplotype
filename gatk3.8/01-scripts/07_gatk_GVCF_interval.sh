#!/bin/bash
if [ $# -ne 3 ]; then
        echo "Expecting the following 3 parameters  on the command line, in that order"
        echo "path to the fasta file with its full name "
        echo "Number of intervals to split the fasta file"
        echo "Name of the bam file (obtained after running bwa-mem, add RG and dedup)"
else
        #Using values from the command line
        assembly=$1   #"example: 03_genome/yourgenome.fasta" 
        intervals=$2  # expected nb intervals (number of intervals created can be slightly lower or higher)
        bam=$3        #name of the bam one by individual
        echo "assembly=$assembly"
        echo "nb intervals=$intervals"
        echo "bam=$bam"
fi

BAM=$(basename $bam)
DATAFOLDER=$(pwd)
GENOMEFOLDER=${DATAFOLDER}/"03_genome"
GENOME="hmel2_plus_mt.fa"
REF="$GENOMEFOLDER"/"$GENOME"
INFOLDER="08_cleaned_bam"
OUTFOLDER="09_haplotype_caller38"
mkdir $OUTFOLDER 2>/dev/null
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
    echo "module load gatk/3.7" >> lanceur_interval.$i.sh
    echo " java -jar \$EBROOTGATK/GenomeAnalysisTK.jar \\">> lanceur_interval.$i.sh 
    echo "  -T HaplotypeCaller \\">> lanceur_interval.$i.sh 
    echo "  -R "$REF" \\">> lanceur_interval.$i.sh 
    echo "  -nct 8 \\">> lanceur_interval.$i.sh 
    echo "  -I $DATAFOLDER/$INFOLDER/$BAM  \\" >> lanceur_interval.$i.sh
    echo "  --variant_index_type LINEAR \\">> lanceur_interval.$i.sh 
    echo "  --variant_index_parameter 128000 \\">> lanceur_interval.$i.sh 
    echo "  --emitRefConfidence GVCF  \\">> lanceur_interval.$i.sh 
    echo "  --genotyping_mode DISCOVERY  \\">> lanceur_interval.$i.sh 
    echo "  -hets 0.015\\">> lanceur_interval.$i.sh 
    echo "  -indelHeterozygosity 1.25E-4 \\">> lanceur_interval.$i.sh 
    echo "  --min_base_quality_score 25 --min_mapping_quality_score 25 \\">> lanceur_interval.$i.sh 
    echo "  -stand_call_conf 20 \\">> lanceur_interval.$i.sh 
    echo "  -o "$DATAFOLDER"/"$OUTFOLDER"/"${BAM%.dedup}".$i.g.vcf.gz \\">> lanceur_interval.$i.sh 
    echo "  -L $DATAFOLDER/tmp_haplotypcaller_$BAM/$i \\" >> lanceur_interval.$i.sh 
done

