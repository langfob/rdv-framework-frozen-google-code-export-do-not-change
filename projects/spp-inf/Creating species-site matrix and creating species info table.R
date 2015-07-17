
rm(list = ls())

library(raster)
library(sp)
library(picante)

setwd("Zonation runs/Test data")
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

# If distributions need to be thresholded to presence-absences
#sp_site_m[sp_site_m[] > 0.5] <- 1 #NB! what threshold do we need to use?
#sp_site_m[sp_site_m[] < 1] <- 0



# create a sp characteristics table

sp_info <- data.frame(sp=names, dist_sum=NA, dist_richness=NA, mean_jaccard_similarity=NA)

# distribution size (from original probability values)
sp_info$dist_sum <- read.table('Output/out_all.features_info.txt', skip=1, header=T, sep='')[,2]

# average weighted sp richness within distribution (suitable for both continuous and binary data)
for (i in 1:length(names)){
  sp_info$dist_richness[i] <- weighted.mean(apply(sp_site_m[,-i], 1, sum), sp_site_m[,i])
}

# calculate co-occurrence using 'picante' package
cooc <- as.matrix(species.dist(sp_site_m, metric = 'jaccard'))  # creates a co-occurrence matrix, metric options: c("cij", "jaccard", "checkerboard", "doij")
diag(cooc) <- NA # change diagonal values to NA

for (i in 1:length(names)){
  sp_info$mean_jaccard_similarity[i] <- mean(cooc[,i], na.rm=T)
}

setwd("../../" )

save(sp_info, file='sp_info.rdump')
