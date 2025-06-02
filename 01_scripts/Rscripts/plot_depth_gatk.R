#purpose = "plot depth for each SNP and each individuals in a vcf"
#date    = "14/05/2019"
#authors =  "Quentin Rougemont"
#input   = "compressed depth file obtained after running gatk DP command"
#output  = "plot of depth for each individual"

if("ggplot2" %in% rownames(installed.packages()) == FALSE)
    {install.packages("ggplot2", repos="https://cloud.r-project.org") }
if("data.table" %in% rownames(installed.packages()) == FALSE)
    {install.packages("data.table", repos="https://cloud.r-project.org") }

library(ggplot2)
library(data.table)

argv  <- commandArgs(TRUE)
if (argv[1]=="-h" || length(argv)==0){
        cat("\n compressed VQSR table file needed!! \n")
        cat("\n Can be obtained by running script 16_extract_VQSR_snp.sh\n")
}else{
dp  <- argv[1] #vqsr file table (must be compressed) 
}
dp <- paste("zcat", dp ,sep=" ") 
DP <- fread(dp)

colnames(DP) <- c("IND","MEAN_DEPTH")

nsnp <- 20467458 #total number of snp #can be obtained by table (DP$IND)
#nsnp <- table(DP$IND)[1] #takes longer...

DP1 <- DP[1:(10*nsnp),]
DP2 <- DP[((10*nsnp)+1):(20*nsnp),]
DP3 <- DP[((20*nsnp)+1):(30*nsnp),]
DP4 <- DP[((30*nsnp)+1):(40*nsnp),]
DP5 <- DP[((40*nsnp)+1):(55*nsnp),]

DP1 <- na.omit(DP1)
DP2 <- na.omit(DP2)
DP3 <- na.omit(DP3)
DP4 <- na.omit(DP4)
DP5 <- na.omit(DP5)

p1 <- ggplot(DP1, aes(x=MEAN_DEPTH)) + 
    geom_density(alpha=.3) +
    xlim(0,200) +
    facet_wrap( ~ IND, ncol = 5) +
    geom_vline(xintercept=c(10))
    
p2 <- ggplot(DP2, aes(x=MEAN_DEPTH)) + 
    geom_density(alpha=.3) +
    xlim(0,200) +
    facet_wrap( ~ IND, ncol = 5) +
    geom_vline(xintercept=c(10))

p3 <- ggplot(DP3, aes(x=MEAN_DEPTH)) + 
    geom_density(alpha=.3) +
    xlim(0,200) +
    facet_wrap( ~ IND, ncol = 5) +
    geom_vline(xintercept=c(10))

p4 <- ggplot(DP4, aes(x=MEAN_DEPTH)) + 
    geom_density(alpha=.3) +
    xlim(0,200) +
    facet_wrap( ~ IND, ncol = 5) +
    geom_vline(xintercept=c(10))

p5 <- ggplot(DP5, aes(x=MEAN_DEPTH)) + 
    geom_density(alpha=.3) +
    xlim(0,200) +
    facet_wrap( ~ IND, ncol = 5) +
    geom_vline(xintercept=c(10))

pdf("DEPTH_1.pdf",15,10)
    p1
dev.off()

pdf("DEPTH_2.pdf",15,10)
    p2
dev.off()

pdf("DEPTH_3.pdf",15,10)
    p3
dev.off()

pdf("DEPTH_4.pdf",15,10)
    p4
dev.off()

pdf("DEPTH_5.pdf",15,10)
    p5
dev.off()
