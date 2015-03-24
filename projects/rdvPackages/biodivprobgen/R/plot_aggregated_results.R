#===============================================================================

                    #  plot_aggregated_results.R

#===============================================================================

    #  Generate some images for the VxLabs wall.

x = read.csv ("/Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R/Aggregated_results/aggregated_prob_diff_results.runs_1-100.sets_301_401_501_601 - recognizer only.csv")
#x = read.csv ("/Users/bill/tzar/outputdata/biodivprobgen/default_runset/499_default_scenario/prob_diff_results.csv")
names(x)
attach (x)

tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "runset.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ runset ) ; dev.off()
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "run_ID.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ run_ID ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "num_PUs.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ num_PUs ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "num_spp.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ num_spp ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "abs_marxan_best_solution_cost_err_frac.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ abs_marxan_best_solution_cost_err_frac ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "connectance.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ connectance ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "web_asymmetry.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ web_asymmetry ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "links_per_species.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ links_per_species ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "cluster_coefficient.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ cluster_coefficient ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "weighted_NODF.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ weighted_NODF ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "interaction_strength_asymmetry.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ interaction_strength_asymmetry ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "specialisation_asymmetry.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ specialisation_asymmetry ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "linkage_density.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ linkage_density ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "weighted_connectance.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ weighted_connectance ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "Shannon_diversity.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ Shannon_diversity ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "interaction_evenness.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ interaction_evenness ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "Alatalo_interaction_evenness.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ Alatalo_interaction_evenness ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "number.of.species.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ number.of.species.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "number.of.species.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ number.of.species.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "mean.number.of.shared.partners.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ mean.number.of.shared.partners.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "mean.number.of.shared.partners.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ mean.number.of.shared.partners.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "cluster.coefficient.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ cluster.coefficient.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "cluster.coefficient.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ cluster.coefficient.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "niche.overlap.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ niche.overlap.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "niche.overlap.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ niche.overlap.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "togetherness.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ togetherness.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "togetherness.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ togetherness.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "C.score.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ C.score.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "C.score.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ C.score.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "V.ratio.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ V.ratio.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "V.ratio.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ V.ratio.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "functional.complementarity.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ functional.complementarity.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "functional.complementarity.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ functional.complementarity.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "partner.diversity.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ partner.diversity.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "partner.diversity.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ partner.diversity.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "generality.HL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ generality.HL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "vulnerability.LL.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ vulnerability.LL ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_top.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_top ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_bottom.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_bottom ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_num_edges_m.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_num_edges_m ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_ktop.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_ktop ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_kbottom.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_kbottom ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_bidens.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_bidens ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_lcctop.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_lcctop ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_lccbottom.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_lccbottom ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_distop.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_distop ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_disbottom.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_disbottom ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_cctop.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_cctop ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_ccbottom.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_ccbottom ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_cclowdottop.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_cclowdottop ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_cclowdotbottom.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_cclowdotbottom ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_cctopdottop.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_cctopdottop ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_cctopdotbottom.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_cctopdotbottom ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_mean_bottom_bg_redundancy.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_mean_bottom_bg_redundancy ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_median_bottom_bg_redundancy.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_median_bottom_bg_redundancy ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_mean_top_bg_redundancy.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_mean_top_bg_redundancy ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "ig_median_top_bg_redundancy.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ ig_median_top_bg_redundancy ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "num_spp_over_num_PUs.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ num_spp_over_num_PUs ); dev.off() 
tiff (paste0("/Users/bill/Desktop/VxLabsWallImages/", "num_PUs_over_num_spp.tiff")); plot (abs_marxan_best_solution_cost_err_frac ~ num_PUs_over_num_spp ); dev.off()

#===============================================================================

    #  Plot some images of the data after you've cut one variable at a 
    #  threshold where you think it splits into error vs. no error.

x = read.csv ("/Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R/Aggregated_results/aggregated_prob_diff_results.runs_1-100.sets_301_401_501_601 - recognizer only.csv")
#x = read.csv ("/Users/bill/tzar/outputdata/biodivprobgen/default_runset/499_default_scenario/prob_diff_results.csv")
names(x)
attach (x)


#  for (nnn in names(x)) cat ("\n\t\t\t", nnn, " + ")

        #####  NOTE:  COULD SAVE ALL OF THESE TO INDIVIDUAL FILES AND 
        #####         USE THEM AS EXAMPLES FOR VISUALLY SORTING ON THE 
        #####         BIG WALL AT VXLABS.

plot (abs_marxan_best_solution_cost_err_frac ~ 
        	 runset_abbrev  + 
			 run_ID  + 
			 num_PUs  + 
			 num_spp  + 
			 abs_marxan_best_solution_cost_err_frac  + 
			 connectance  + 
			 web_asymmetry  + 
			 links_per_species  + 
			 cluster_coefficient  + 
			 weighted_NODF  + 
			 interaction_strength_asymmetry  + 
			 specialisation_asymmetry  + 
			 linkage_density  + 
			 weighted_connectance  + 
			 Shannon_diversity  + 
			 interaction_evenness  + 
			 Alatalo_interaction_evenness  + 
			 number.of.species.HL  + 
			 number.of.species.LL  + 
			 mean.number.of.shared.partners.HL  + 
			 mean.number.of.shared.partners.LL  + 
			 cluster.coefficient.HL  + 
			 cluster.coefficient.LL  + 
			 niche.overlap.HL  + 
			 niche.overlap.LL  + 
			 togetherness.HL  + 
			 togetherness.LL  + 
			 C.score.HL  + 
			 C.score.LL  + 
			 V.ratio.HL  + 
			 V.ratio.LL  + 
			 functional.complementarity.HL  + 
			 functional.complementarity.LL  + 
			 partner.diversity.HL  + 
			 partner.diversity.LL  + 
			 generality.HL  + 
			 vulnerability.LL  + 
			 ig_top  + 
			 ig_bottom  + 
			 ig_num_edges_m  + 
			 ig_ktop  + 
			 ig_kbottom  + 
			 ig_bidens  + 
			 ig_lcctop  + 
			 ig_lccbottom  + 
			 ig_distop  + 
			 ig_disbottom  + 
			 ig_cctop  + 
			 ig_ccbottom  + 
			 ig_cclowdottop  + 
			 ig_cclowdotbottom  + 
			 ig_cctopdottop  + 
			 ig_cctopdotbottom  + 
			 ig_mean_bottom_bg_redundancy  + 
			 ig_median_bottom_bg_redundancy  + 
			 ig_mean_top_bg_redundancy  + 
			 ig_median_top_bg_redundancy  + 
			 num_spp_over_num_PUs  + 
			 num_PUs_over_num_spp  
      )

y = which (ig_mean_top_bg_redundancy > 0)
z = x[y,]

aaa = which (mean.number.of.shared.partners.LL > 0.0855)
bbb = x[aaa,]

detach(x)
attach(z)

plot (abs_marxan_best_solution_cost_err_frac ~ 
             runset  + 
			 run_ID  + 
			 num_PUs  + 
			 num_spp  + 
			 abs_marxan_best_solution_cost_err_frac  + 
			 connectance  + 
			 web_asymmetry  + 
			 links_per_species  + 
			 cluster_coefficient  + 
			 weighted_NODF  + 
			 interaction_strength_asymmetry  + 
			 specialisation_asymmetry  + 
			 linkage_density  + 
			 weighted_connectance  + 
			 Shannon_diversity  + 
			 interaction_evenness  + 
			 Alatalo_interaction_evenness  + 
			 number.of.species.HL  + 
			 number.of.species.LL  + 
			 mean.number.of.shared.partners.HL  + 
			 mean.number.of.shared.partners.LL  + 
			 cluster.coefficient.HL  + 
			 cluster.coefficient.LL  + 
			 niche.overlap.HL  + 
			 niche.overlap.LL  + 
			 togetherness.HL  + 
			 togetherness.LL  + 
			 C.score.HL  + 
			 C.score.LL  + 
			 V.ratio.HL  + 
			 V.ratio.LL  + 
			 functional.complementarity.HL  + 
			 functional.complementarity.LL  + 
			 partner.diversity.HL  + 
			 partner.diversity.LL  + 
			 generality.HL  + 
			 vulnerability.LL  + 
			 ig_top  + 
			 ig_bottom  + 
			 ig_num_edges_m  + 
			 ig_ktop  + 
			 ig_kbottom  + 
			 ig_bidens  + 
			 ig_lcctop  + 
			 ig_lccbottom  + 
			 ig_distop  + 
			 ig_disbottom  + 
			 ig_cctop  + 
			 ig_ccbottom  + 
			 ig_cclowdottop  + 
			 ig_cclowdotbottom  + 
			 ig_cctopdottop  + 
			 ig_cctopdotbottom  + 
			 ig_mean_bottom_bg_redundancy  + 
			 ig_median_bottom_bg_redundancy  + 
			 ig_mean_top_bg_redundancy  + 
			 ig_median_top_bg_redundancy  + 
			 num_spp_over_num_PUs  + 
			 num_PUs_over_num_spp  
      )

detach (z)

attach(bbb)

plot (abs_marxan_best_solution_cost_err_frac ~ 
             runset  + 
    		 run_ID  + 
			 num_PUs  + 
			 num_spp  + 
			 abs_marxan_best_solution_cost_err_frac  + 
			 connectance  + 
			 web_asymmetry  + 
			 links_per_species  + 
			 cluster_coefficient  + 
			 weighted_NODF  + 
			 interaction_strength_asymmetry  + 
			 specialisation_asymmetry  + 
			 linkage_density  + 
			 weighted_connectance  + 
			 Shannon_diversity  + 
			 interaction_evenness  + 
			 Alatalo_interaction_evenness  + 
			 number.of.species.HL  + 
			 number.of.species.LL  + 
			 mean.number.of.shared.partners.HL  + 
			 mean.number.of.shared.partners.LL  + 
			 cluster.coefficient.HL  + 
			 cluster.coefficient.LL  + 
			 niche.overlap.HL  + 
			 niche.overlap.LL  + 
			 togetherness.HL  + 
			 togetherness.LL  + 
			 C.score.HL  + 
			 C.score.LL  + 
			 V.ratio.HL  + 
			 V.ratio.LL  + 
			 functional.complementarity.HL  + 
			 functional.complementarity.LL  + 
			 partner.diversity.HL  + 
			 partner.diversity.LL  + 
			 generality.HL  + 
			 vulnerability.LL  + 
			 ig_top  + 
			 ig_bottom  + 
			 ig_num_edges_m  + 
			 ig_ktop  + 
			 ig_kbottom  + 
			 ig_bidens  + 
			 ig_lcctop  + 
			 ig_lccbottom  + 
			 ig_distop  + 
			 ig_disbottom  + 
			 ig_cctop  + 
			 ig_ccbottom  + 
			 ig_cclowdottop  + 
			 ig_cclowdotbottom  + 
			 ig_cctopdottop  + 
			 ig_cctopdotbottom  + 
			 ig_mean_bottom_bg_redundancy  + 
			 ig_median_bottom_bg_redundancy  + 
			 ig_mean_top_bg_redundancy  + 
			 ig_median_top_bg_redundancy  + 
			 num_spp_over_num_PUs  + 
			 num_PUs_over_num_spp  
      )

#===============================================================================

    #  Can you run xkcd on these?  Might be interesting, at least for eric...
    #  Run the following to get an explanation of how to use the package:
    #      vignette("xkcd-intro")
    #  Looks like more learning is required than I have time for at the moment...
    
#library (xkcd)

#===============================================================================

    #  Function to write multiple objects to a single Excel file, 
    #  with each object on a separate worksheet.  
    #  Each sheet is given the same name as the object written to it.
    #  Copied (and slightly modifed) from Robert I. Kabacoff's 
    #  statMethods blog, June 19, 2014 entry:
    #       "Quickly export multiple R objects to an Excel Workbook"
    #       https://statmethods.wordpress.com/2014/06/19/quickly-export-multiple-r-objects-to-an-excel-workbook/
    #       "The method will work for data frames, matrices, time series, 
    #        and tables"

    #  Notes:
    #   1) The output file has a column inserted at the left edge and it 
    #       displays the row number (row name? if there is one?).
    #   2) That column generates a warning when read into Excel because it 
    #       is "a number displayed as text".
    #   These two things are controlled by the call to write.xlsx(), which 
    #   has a default argument for showing row and column names.  However, 
    #   that can be changed, so I'm adding those arguments to the call 
    #   until I know how this needs to be done for mappr. 
    #
    #   3) Same goes for whether NAs are shown as NA or as blank.
    #       However, blanks are shown as blank, so I need to make sure that 
    #       blanks are handled according to what mappr expects, particularly 
    #       wrt the first data line in the file.
    #
    #   4) The original version of this function called write.xlsx(), but 
    #       it was slow writing big spreadsheets, so I changed the call to 
    #       use write.xlsx2() since the helpf for xlsx says:
    #       "Function write.xlsx2 uses addDataFrame which speeds up the 
    #        execution compared to write.xlsx by an order of magnitude 
    #        for large spreadsheets (with more than 100,000 cells)."
    #       Even though what I writing out was not 100,000 cells, it 
    #       was still slow and is now much faster.

save.xlsx <- function (file, ...)
    {
    require (xlsx, quietly = TRUE)
    
        #  Get unknown number of objects handed in as arguments to the function.
    objects <- list (...)    #  Objects passed in and to be written as sheets.    
    nobjects <- length (objects)

        #  Get object names to use as labels for worksheets.
    fargs <- as.list (match.call (expand.dots = TRUE))
    objnames <- as.character (fargs) [-c(1, 2)]
    
        #  Write one sheet for each object.
    for (i in 1:nobjects) 
        {
        if (i == 1)    #  Create the first sheet, i.e., don't append.
            {
            write.xlsx2 (objects[[i]], file, sheetName = objnames[i],
                        row.names=TRUE, 
                        showNA=TRUE, 
                        col.names=TRUE
                        )
            
            } else    #  Append a new sheet
            {
            write.xlsx2 (objects[[i]], file, sheetName = objnames[i],
                         
                        append = TRUE,
                        
                        row.names=TRUE, 
                        showNA=TRUE, 
                        col.names=TRUE
                        )
            }
        }
    
    print (paste ("Workbook", file, "has", nobjects, "worksheets."))
    }

testfile = "/Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R/testout.xlsx"
save.xlsx (testfile, x, z)

#===============================================================================

