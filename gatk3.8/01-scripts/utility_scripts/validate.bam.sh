#!/bin/bash                                                                                         
                                                                                                    
bam=$1                                                                                              
if [ $# -eq 0 ]                                                                                     
then                                                                                                
        echo "error need bam file "                                                                 
        exit                                                                                        
fi                                                                                                  
                                                                                                    
file=$(basename "$bam" )                                                                            
file_path=$(pwd)                                                                                   
# Global variables                                                                                  
validate="/prg/picard-tools/1.119/ValidateSamFile.jar"                                              
mkdir tmp

java -jar -Djava.io.tmpdir=./tmp  $validate \                                                       
      I="$file_path"/09_no_overlap/"$file"\                                                         
      MODE=SUMMARY\                                                                                 
      TMP_DIR=./tmp                                                                                 

