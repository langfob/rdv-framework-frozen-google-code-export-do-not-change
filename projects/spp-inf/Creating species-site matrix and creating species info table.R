library(raster)
library(sp)
library(picante)

setwd("C:/Users/hkujala/work/Species influence/src/Zonation runs/Test data")
names <- c('Sp1', 'Sp2', 'Sp3', 'Sp4', 'Sp5', 'Sp6', 'Sp7')


# Create a species-site matrix
temp.r <- na.omit(as.vector(raster('Species/species1.asc')))

sp_dist_path <- 'Species/species%s.asc'
sp <- c(1:7)

sp_site_m <- matrix(NA, length(temp.r), length(names))
colnames(sp_site_m) <- names
sites <- nrow(sp_site_m)

for(i in seq_along(sp)) {
  sp_site_m[, i] <- na.omit(as.vector(raster(sprintf(sp_dist_path, i))))
}

sp_site_m[sp_site_m[] > 0.5] <- 1 #NB! what threshold do we need to use?
sp_site_m[sp_site_m[] < 1] <- 0



# create a sp characteristics table

sp_info <- data.frame(sp=names, dist_sum=NA, dist_richness=NA, mean_jaccard_similarity=NA)

# distribution size (from original probability values)
sp_info$dist_sum <- read.table('Output/out_all.features_info.txt', skip=1, header=T, sep='')[,2]

# average sp richness within distribution
for (i in 1:length(names)){
  sp_info$dist_richness[i] <- mean(apply(sp_site_m[sp_site_m[,i]==1,], 1, sum)-1)
}

# calculate co-occurrence using 'picante' package
cooc <- as.matrix(species.dist(sp_site_m, metric = 'jaccard'))  # creates a co-occurrence matrix, metric options: c("cij", "jaccard", "checkerboard", "doij")
diag(cooc) <- NA # change diagonal values to NA

for (i in 1:length(names)){
  sp_info$mean_jaccard_similarity[i] <- mean(cooc[,i], na.rm=T)
}

save(sp_info, file='C:/Users/hkujala/work/Species influence/src/sp_info.r')



# plots
load(file='C:/Users/hkujala/work/Species influence/src/sp_info.r')
load(file='C:/Users/hkujala/work/Species influence/src/sp_influence.r') # NB! object called 'results_all'

# absolute differene in ranks
png("Absolute difference in ranks.png", height=12, width=15, units="cm", res=300, bg="transparent", pointsize=11)
par(mfrow=c(2,2), mar=c(4,2,1,1), oma=c(0,3,0,0))
plot(sp_info$dist_sum, results_all$Rank_diff, ylab='', xlab='Distribution sum', pch=19)
plot(sp_info$dist_richness, results_all$Rank_diff, ylab='', xlab='Average sp richness within distribution', pch=19)
plot(sp_info$mean_jaccard_similarity, results_all$Rank_diff, ylab='', xlab='Mean Jaccard similarity', pch=19)
mtext('Absolute difference in ranks', 2, outer=T, line=1)
dev.off()


# Sum of AUCs
png("Sum of AUCs.png", height=12, width=15, units="cm", res=300, bg="transparent", pointsize=11)
par(mfrow=c(2,2), mar=c(4,2,1,1), oma=c(0,3,0,0))
plot(sp_info$dist_sum, results_all$AUC_sum, ylab='', xlab='Distribution sum', pch=19)
plot(sp_info$dist_richness, results_all$AUC_sum, ylab='', xlab='Average sp richness within distribution', pch=19)
plot(sp_info$mean_jaccard_similarity, results_all$AUC_sum, ylab='', xlab='Mean Jaccard similarity', pch=19)
mtext('Sum of AUCs', 2, outer=T, line=1)
dev.off()
