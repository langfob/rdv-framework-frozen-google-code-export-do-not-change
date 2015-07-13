library(pracma)
setwd("C:/Users/hkujala/work/Species influence/src/Zonation runs/Test data")


names <- c('Sp1', 'Sp2', 'Sp3', 'Sp4', 'Sp5', 'Sp6', 'Sp7')
results <- data.frame(names,NA)
colnames(results) <- c('Species', 'AUC_sum')

for (i in 1:length(names)){
  curves_1missing <- read.table(paste0('Output/out_missing', names[i], '.curves.txt'), skip=1, header=F, sep='')[, c(1,8:(7+length(names)-1))]
  auc <- 0
  for (j in 1:(length(names)-1)){
    auc <- auc + trapz(curves_1missing[,1], curves_1missing[,1+j])
  }
  results[i,2] <- auc
}

save(results, file="C:/Users/hkujala/work/Species influence/src/AUC_sum.r")