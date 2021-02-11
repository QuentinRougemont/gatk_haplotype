#!/bin/bash
#!/bin/bash
#PBS -A ihv-653-aa
#PBS -N merge__
#PBS -l walltime=48:00:00
#PBS -l nodes=1:ppn=8
#PBS -r n
# Move to job submission directory
cd $PBS_O_WORKDIR

module load compilers/java/1.8
input=$1 #bam to validate
output=$input ##basename of the output

################## run gatk ########################################
echo "############# Running GATK ###########"

java -jar picard.jar ValidateSamFile \
      I=$input \
      MODE=SUMMARY

