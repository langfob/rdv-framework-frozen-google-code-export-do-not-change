
rm( list = ls( all=TRUE ))

# read in the solution with all spp
all.spp.soln.filename <- "Zonation runs/Test data/Output/out_all.rank.asc"
cat ( '\nReading in file', all.spp.soln.filename )
all.spp.soln <- read.table( all.spp.soln.filename, skip=6 )


missing.sp.solns.path <- "Zonation runs/Test data/Output/out_missingsp%s.rank.asc"


calc.overlap <- function(soln.all, soln.missing, thresholds ){


    overlap.props <- vector( length=length(thresholds))

    
    for( thresh in 1:length(thresholds) ) {

        all.above.thresh <- which(soln.all > thresholds[thresh] )
        spp.above.thresh <- which(soln.missing > thresholds[thresh] )

        # check that both files have the same lenthg
        if ( length(spp.above.thresh) != length( spp.above.thresh ) ) {
            stop( "\n\nerror, the no of pixels above threshold differ for the two maps!" )
        }
        
        no.of.pixels.overlap <- length(which( spp.above.thresh %in% all.above.thresh ))
       
        cur.prop.overlap <- no.of.pixels.overlap / length(spp.above.thresh )

        # save the current overlap proportion
        overlap.props[thresh] <- cur.prop.overlap

        # wite the value to screen
        cat( '\nthresh =', thresholds[thresh], 'prop overlap=', cur.prop.overlap, 'no.pixels overlap=', no.of.pixels.overlap  )

    }

    return( overlap.props )
    
    
}


par(mfrow = c(3,3) )

# the species to run over
sp <- c(1:7)

# the thresholds over which to calculate the differences
thresholds <- seq(0.999, 0.5, -0.05)

# made a data.frame to store the results in 
overlaps.df <- data.frame( Thresholds=thresholds )

for(i in sp) {
    cur.sol.filename <- sprintf(missing.sp.solns.path, i)
    cat ( '\nreading in file', cur.sol.filename )
    cur.sol <- read.table( cur.sol.filename, skip=6 )

    overlaps <- calc.overlap(all.spp.soln, cur.sol, thresholds)

    #plot( thresholds, overlaps, type = 'l', ylim=c(0.5,1) )

    # add the overlap values for the current spp to the dataframe
    overlaps.df <- cbind(overlaps.df, overlaps )    
}

# Add column names to the data.frame
col.names <- c('thresholds', paste('sp', sp, sep='') )
colnames(overlaps.df) <- col.names


# now plot the results

plot.results <- function() {
    for( i in 1:length(sp)) {

        # get the max and min y-values (note exluce the first col as it's the x values)
        max.y.val <- max(overlaps.df[-1])
        min.y.val <- min(overlaps.df[-1])
        
        plot( overlaps.df$thresholds, overlaps.df[,i+1], type='l', ylim=c(min.y.val, max.y.val) )

    }
}

plot.results()
