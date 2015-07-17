rm(list = ls())

library(raster)



# plots
load(file='Output/sp_info.rdump')
load(file='Output/sp_influence.rdump') # NB! object called 'results_all'
load(file='Output/mean_diff_AUC.rdump')

# absolute differene in ranks
png("Absolute difference in ranks.png", height=12, width=15, units="cm", res=300, bg="transparent", pointsize=11)
par(mfrow=c(2,2), mar=c(4,2,1,1), oma=c(0,3,0,0))
plot(sp_info$dist_sum, results_all$Rank_diff, ylab='', xlab='Distribution sum', pch=19)
plot(sp_info$dist_richness, results_all$Rank_diff, ylab='', xlab='Average sp richness within distribution', pch=19)
plot(sp_info$mean_jaccard_similarity, results_all$Rank_diff, ylab='', xlab='Mean Jaccard similarity', pch=19)
mtext('Absolute difference in ranks', 2, outer=T, line=1)
dev.off()


# Mean change in AUCs of included sp
png("Output/Mean change in AUC.png", height=12, width=15, units="cm", res=300, bg="transparent", pointsize=11)
par(mfrow=c(2,2), mar=c(4,2,1,1), oma=c(0,3,0,0))
plot(sp_info$dist_sum, mean_diff_auc$Mean_DAUC, ylab='', xlab='Distribution sum', pch=19)
abline(h=0, lty=2, col='grey')
plot(sp_info$dist_richness, mean_diff_auc$Mean_DAUC, ylab='', xlab='Average sp richness within distribution', pch=19)
abline(h=0, lty=2, col='grey')
plot(sp_info$mean_jaccard_similarity, mean_diff_auc$Mean_DAUC, ylab='', xlab='Mean Jaccard similarity', pch=19)
abline(h=0, lty=2, col='grey')
mtext('Mean change in AUCs', 2, outer=T, line=1)
dev.off()
