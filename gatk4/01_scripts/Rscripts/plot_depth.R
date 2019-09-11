#purpose = "plot depth for each SNP in a vcf"
#date    = "14/05/2019"
#authors =  "Quentin Rougemont"
#input   = "compressed depth file obtained after running vcftools --site-mean-depth command"
#output  = "plot of depth globally"

if("ggplot2" %in% rownames(installed.packages()) == FALSE)
    {install.packages("ggplot2", repos="https://cloud.r-project.org") }
if("data.table" %in% rownames(installed.packages()) == FALSE)
    {install.packages("data.table", repos="https://cloud.r-project.org") }

library(ggplot2)
library(data.table)
library(cowplot)

argv  <- commandArgs(TRUE)
if (argv[1]=="-h" || length(argv)==0){
        cat("\n compressed VQSR table file needed!! \n  
	cat("\n Can be obtained by running script 16_extract_VQSR_snp.sh"
    \n" )
}else{
dp  <- argv[1] vqsr file table (must be compressed) 
}
dp <- paste("zcat", dp ,sep=" ") 
DP <- fread(dp)

p1 <- ggplot(DP, aes(x=MEAN_DEPTH)) + 
    geom_density(alpha=.3) +
    xlim(0,200) +
     geom_vline(xintercept=c(10))
    
pdf("DEPTH.pdf",15,10)
plot_grid(p1, 
    labels = c('DP'), 
    label_size = 12)
dev.off()
