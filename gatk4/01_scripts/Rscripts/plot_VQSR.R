#purpose = "plot VQSR from SNP vcf"
#date    = "14/05/2019"
#authors =  "Quentin Rougemont"
#output  = "plot of vqsr"

if("ggplot2" %in% rownames(installed.packages()) == FALSE)
    {install.packages("ggplot2", repos="https://cloud.r-project.org") }
if("cowplot" %in% rownames(installed.packages()) == FALSE)
    {install.packages("cowplot", repos="https://cloud.r-project.org") }
if("data.table" %in% rownames(installed.packages()) == FALSE)
    {install.packages("data.table", repos="https://cloud.r-project.org") }

library(cowplot)
library(ggplot2)
library(data.table)

argv  <- commandArgs(TRUE)
if (argv[1]=="-h" || length(argv)==0){
        cat("\n compressed VQSR table file needed!! \n")
        cat("\n Can be obtained by running script 16_extract_VQSR_snp.sh\n" )
}else{
vcf  <- argv[1] #vqsr file table (must be compressed) 
}
vcf <- paste("zcat", vcf ,sep=" ") 
VCF <- fread(vcf)

p0 <- ggplot(VCF, aes(x=QUAL)) + 
    geom_density(alpha=.3) 
p1 <- ggplot(VCF, aes(x=DP)) + 
    geom_density(alpha=.3) 
p2 <- ggplot(VCF, aes(x=QD)) + 
    geom_density(alpha=.3) 
p3 <- ggplot(VCF, aes(x=MQ)) +
    geom_density(alpha=.3) 
p4 <- ggplot(VCF, aes(x=MQRankSum)) +
    geom_density(alpha=.3) 
p5 <- ggplot(VCF, aes(x=FS)) +
    geom_density(alpha=.3) 
p6 <- ggplot(VCF, aes(x=ReadPosRankSum)) +
    geom_density(alpha=.3) 
p7 <- ggplot(VCF, aes(x=SOR)) +
    geom_density(alpha=.3) 
pdf("quality_score.pdf",15,10)
theme_set(theme_cowplot())
plot_grid(p0, p1, p2, p3, p4, p5, p6, p7, 
    nrow = 4,
    labels = c('DP', 'QD','FS','MQ','MQRankSum', 'SOR','ReadPosRankSum'), 
    label_size = 12)
dev.off()
