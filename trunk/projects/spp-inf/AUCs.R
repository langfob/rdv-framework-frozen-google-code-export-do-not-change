rm(list = ls())

library(pracma)


setwd("Zonation runs/Test data")


names <- c('Sp1', 'Sp2', 'Sp3', 'Sp4', 'Sp5', 'Sp6', 'Sp7')


auc.df <- data.frame(matrix(NA, length(names), 3+length(names)))
colnames(auc.df) <- c('Species', 'AUC', 'Mean_other_AUC', sprintf('missing_%s', names))
auc.df$Species <- names


curves_all <- read.table('Output/out_all.curves.txt', skip=1, header=F, sep='')[, c(1,8:(7+length(names)))]
for (j in 1:length(names)){
  auc.df$AUC[j] <- trapz(curves_all[,1], curves_all[,1+j])
}
for (j in 1:length(names)){
  auc.df$Mean_other_AUC[j] <- mean(auc.df$AUC[-j])
}
for (i in 1:length(names)){
  curves_1missing <- read.table(paste0('Output/out_missing', names[i], '.curves.txt'), skip=1, header=F, sep='')[, c(1,8:(7+length(names)-1))]
  incl.sp <- names[-i]
  colnames(curves_1missing) <- c('LS_removed', incl.sp)

  for (j in 1:(length(incl.sp))){
    auc.df[auc.df$Species==incl.sp[j],i+3] <- trapz(curves_1missing[,1], curves_1missing[,1+j])
  }
}  



mean_diff_auc <- data.frame(names,NA)
colnames(mean_diff_auc) <- c('Species', 'Mean_DAUC')

for (i in 1:length(names)){
  mean_diff_auc[i,2] <- mean(auc.df[,i+3] - auc.df$AUC, na.rm=T)
}

save(mean_diff_auc, file="Output/mean_diff_AUC.rdump")


setwd("../../")