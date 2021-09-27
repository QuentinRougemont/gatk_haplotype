#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Usage: $(basename $0) <bam> <chr>" >&2
    echo "bam  individual bam file"
    echo "    NOTE: must be sorted and indexed (see script all previous scripts)"
    echo "chrlist : list of chromosome on which to run separate instance of gatk"
    exit 1
else
        #Using values from the command line
        bam=$1        #name of the bam one by individual
        echo "bam=$bam"
        chr=$2
        echo "chrlist=$chr"
fi

BAM=$(basename $bam)
DATAFOLDER=$(pwd)
GENOMEFOLDER=${DATAFOLDER}/"03_genome"
GENOME="your_genome.fasta"
REF="$GENOMEFOLDER"/"$GENOME"
INFOLDER="08_cleaned_bam"
OUTFOLDER="09_haplotype_caller"
mkdir $OUTFOLDER 2>/dev/null
mkdir tmp_haplotypcaller_$BAM 

# create intervals
for i in $(cat $chr) ; do
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
    echo "gatk --java-options "-Xmx8G" HaplotypeCaller \\">> lanceur_interval.$i.sh 
    echo "     -R $REF \\">> lanceur_interval.$i.sh 
    echo "    -I $DATAFOLDER/$INFOLDER/$BAM -ERC GVCF \\" >> lanceur_interval.$i.sh
    echo "    --heterozygosity 0.0015 --indel-heterozygosity 0.001 \\" >> lanceur_interval.$i.sh
    echo "    -O $DATAFOLDER/$OUTFOLDER/"${BAM%.dedup.bam}".$i.g.vcf.gz \\" >> lanceur_interval.$i.sh
    echo "    -L $i \\" >> lanceur_interval.$i.sh 
done

mv lanceur_interval.*sh tmp_haplotypcaller_$BAM
