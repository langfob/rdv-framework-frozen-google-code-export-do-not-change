#===============================================================================

                    #  gscp_14_read_marxan_output_files.R

#===============================================================================

timepoints_df = 
    timepoint (timepoints_df, "gscp_14", 
               "Starting gscp_14_read_marxan_output_files.R")

#===============================================================================

    #  For each step in order by Marxan summed solution PU ID:
    #  Want the fraction of all species who have met or exceeded their target 
    #  when all PUs with the same number of votes or more are included in the 
    #  solution.

plot_incremental_marxan_summed_solution_representations = 
    function (marxan_ssoln_df, 
              PU_costs, 
              optimum_cost, 
              bpm, 
              cor_app_prefix_string, 
              num_spp, 
              plot_output_dir, 
              DEBUG_LEVEL
              ) 
    {
    
    marxan_ssoln_PUs_ranked_by_votes_df = arrange (marxan_ssoln_df, desc (number))
    
    total_landscape_cost = sum (PU_costs)
    correct_optimum_landscape_frac_cost = optimum_cost / total_landscape_cost
    
    rle_lengths_and_values = rle (marxan_ssoln_PUs_ranked_by_votes_df [, "number"])
    num_runs = length (rle_lengths_and_values$values)
    
    cur_run_start_idx = 1
    cur_run_index = 0
    cur_solution_PUs = c()
    frac_of_all_spp_meeting_their_target = rep (0.0, num_runs)
    cost = rep (0, num_runs)
    landscape_frac_cost = rep (0, num_runs)
    optimal_frac_cost = rep (0, num_runs)
    frac_rep_met_over_optimal_frac_cost = rep (0, num_runs)
    thresh_found = FALSE
    cost_thresh_for_all_spp_meeting_targets = total_landscape_cost
    landscape_frac_cost_thresh_for_all_spp_meeting_targets = 1.0
    optimal_frac_cost_thresh_for_all_spp_meeting_targets = 
        total_landscape_cost / optimum_cost
    
    for (cur_run_length in rle_lengths_and_values$lengths)
        {
        cur_run_index = cur_run_index + 1
        
        cur_run_end_idx_in_PU_IDs = cur_run_start_idx + cur_run_length - 1
        cur_run_indices = cur_run_start_idx : cur_run_end_idx_in_PU_IDs
        
        cur_solution_PUs = 
        c(cur_solution_PUs, 
        marxan_ssoln_PUs_ranked_by_votes_df [cur_run_indices, "planning_unit"])
        
        cur_rep_fractions = compute_rep_fraction (bpm, 
                                        cur_solution_PUs, 
                                        DEBUG_LEVEL, 
                                        rep (1, num_spp))
        cur_num_spp_meeting_their_target = sum (cur_rep_fractions >= 1.0)  #  How best to give a tolerance here?
        cur_frac_of_all_spp_meeting_their_target = 
        cur_num_spp_meeting_their_target / num_spp
        frac_of_all_spp_meeting_their_target [cur_run_index] = 
        cur_frac_of_all_spp_meeting_their_target
        
        #--------------------
        
        cur_cost = compute_solution_cost (cur_solution_PUs, PU_costs)
        cost [cur_run_index] = cur_cost
        
        cur_landscape_frac_cost = cur_cost / total_landscape_cost
        landscape_frac_cost [cur_run_index] = cur_landscape_frac_cost
        
        cur_optimal_frac_cost = cur_cost / optimum_cost
        optimal_frac_cost [cur_run_index] = cur_optimal_frac_cost
        
        #--------------------
        
        cur_frac_rep_met_over_optimal_frac_cost = 
        cur_frac_of_all_spp_meeting_their_target / cur_optimal_frac_cost
        frac_rep_met_over_optimal_frac_cost [cur_run_index] = cur_frac_rep_met_over_optimal_frac_cost
        
        #--------------------
        
        if (!thresh_found)
            {
            if (cur_frac_of_all_spp_meeting_their_target >= 1.0)
                {
                thresh_found = TRUE
                
                cost_thresh_for_all_spp_meeting_targets = cur_cost
                landscape_frac_cost_thresh_for_all_spp_meeting_targets = 
                    cur_landscape_frac_cost
                optimal_frac_cost_thresh_for_all_spp_meeting_targets = 
                    cur_optimal_frac_cost
                
                cat ("\n\n>>>>> For marxan summed solution:")
                cat ("\n", cor_app_prefix_string, "_", "cost_thresh_for_all_spp_meeting_targets = ", 
                   cost_thresh_for_all_spp_meeting_targets, sep='')
                cat ("\n", cor_app_prefix_string, "_", "landscape_frac_cost_thresh_for_all_spp_meeting_targets = ", 
                   landscape_frac_cost_thresh_for_all_spp_meeting_targets, sep='')
                cat ("\n", cor_app_prefix_string, "_", "optimal_frac_cost_thresh_for_all_spp_meeting_targets = ", 
                   optimal_frac_cost_thresh_for_all_spp_meeting_targets, sep='')
                
                }  #  end if - all targets met
            }  #  end if - no threshold found yet
        
        #--------------------
        
        if (DEBUG_LEVEL > 0)
            {
            cat ("\n---------------------\n", cur_run_index, ":", sep='')
            print (cur_run_indices)
            cat ("cur_solution_PUs = ")
            print (cur_solution_PUs)
            cat ("\n", cor_app_prefix_string, "_", "cur_frac_of_all_spp_meeting_their_target = ", 
            cur_frac_of_all_spp_meeting_their_target)
            cat ("\n", cor_app_prefix_string, "_", "cur_cost = ", cur_cost)
            cat ("\n", cor_app_prefix_string, "_", "cur_landscape_frac_cost = ", cur_landscape_frac_cost)
            cat ("\n", cor_app_prefix_string, "_", "cur_optimal_frac_cost = ", cur_optimal_frac_cost)
            cat ("\n", cor_app_prefix_string, "_", "cur_frac_rep_met_over_optimal_frac_cost = ", cur_frac_rep_met_over_optimal_frac_cost)
            
            }  #  end if - debugging
        
        cat ("\n")
        
        #--------------------
        
        cur_run_start_idx = cur_run_end_idx_in_PU_IDs + 1
        }
    
    #-------------------------------------------
    #-------------------------------------------
    
###  2015 05 14 - BTL
###  Try converting this to "natural" spline instead of using loess().
###  It may be better-behaved.
###  See the code I saved in running notes file today for an example.

# splined_data <- stats::splinefun (cost, frac_of_all_spp_meeting_their_target,  
#                                     method="natural")

# curve (splined_data, 0.5, 5, 
#         lwd=6, 
#         col="darkblue", 
#         xlab="Experience",
#         ylab="Perceived difficulty",
#          axes=FALSE, 
#         xlim=c(0.4,5)
#         )

    #--------------------

        #  2015 04 10 - BTL
        #  NOTE:  In the following code, the call to loess() is used to make 
        #         a smoother looking approximation to the curve.  
        #         It occasionally generates a 
        #         warning and that causes everything to fail when I have options(warn=2)
        #         set to turn all warnings into errors.
        #         Since this is unimportant code that is only aimed at giving a bit 
        #         more visualization of the results, I'm going to wrap all of the 
        #         loess() calls in suppressWarnings() to keep things from failing.
        
        #  See http://www.statmethods.net/advgraphs/axes.html and 
        #  http://www.statmethods.net/advgraphs/parameters.html 
        #  for help on plot labelling if I need to modify these plots.
    
    pdf (file.path (plot_output_dir, paste0 (cor_app_prefix_string, "_", "marxan_ssoln_frac_rep_vs_raw_cost.pdf")))
    plot (cost, frac_of_all_spp_meeting_their_target, 
          main="Marxan summed solutions\nFraction of spp meeting targets vs. Raw costs", 
          xlab="Solution cost", 
          ylab="Fraction of spp meeting target")

    lines (suppressWarnings (loess (frac_of_all_spp_meeting_their_target ~ cost)))    #  good fit
    #lines (lowess (cost, frac_of_all_spp_meeting_their_target))    #  terrible fit

# splined_data <- stats::splinefun (cost, frac_of_all_spp_meeting_their_target,  
#                                   method="natural")
# curve (splined_data, #0.5, 5, 
#         lwd=6, 
#         col="darkblue" 
# #        xlab="Experience",
# #        ylab="Perceived difficulty",
# #         axes=FALSE, 
# #        xlim=c(0.4,5)
#         )

    abline (v=optimum_cost, lty=2)
    abline (h=1.0, lty=2)
    dev.off()
    
    pdf (file.path (plot_output_dir, paste0 (cor_app_prefix_string, "_", "marxan_ssoln_frac_rep_vs_normalized_cost.pdf")))
    plot (landscape_frac_cost, frac_of_all_spp_meeting_their_target, 
          main="Marxan summed solutions\nFraction of spp meeting targets vs. Normalized costs", 
          xlab="Solution cost as fraction of total landscape cost", 
          ylab="Fraction of spp meeting target")
    lines (suppressWarnings (loess (frac_of_all_spp_meeting_their_target ~ landscape_frac_cost)))    #  good fit
    abline (v=correct_optimum_landscape_frac_cost, lty=4)
    abline (h=1.0, lty=4)
    dev.off()
    
    #--------------------
    
        #  These two seemed like they should be useful, but don't seem to tell 
        #  much.  They just say that you're always getting less bang for your 
        #  buck as you add more planning units.
        #  The plots above seem to tell more about that in that you can see the 
        #  inflection point where the plot starts to bend.
        #  I'll leave them in for now, but could probably chuck them.
    
    pdf (file.path (plot_output_dir, paste0 (cor_app_prefix_string, "_", "marxan_ssoln_frac_rep_vs_frac_optimal_cost.pdf")))
    plot (optimal_frac_cost, frac_of_all_spp_meeting_their_target, 
          main="Marxan summed solutions\nFraction of spp meeting targets vs. Fraction of optimal cost", 
          xlab="Solution cost as fraction of optimal cost", 
          ylab="Fraction of spp meeting target")
    lines (suppressWarnings (loess (frac_of_all_spp_meeting_their_target ~ optimal_frac_cost)))    #  good fit
    abline (v=1, lty=5)
    abline (h=1.0, lty=5)
    dev.off()
    
    pdf (file.path (plot_output_dir, paste0 (cor_app_prefix_string, "_", "marxan_ssoln_frac_rep_over_frac_optimal_cost.pdf")))
    plot (optimal_frac_cost, frac_rep_met_over_optimal_frac_cost, 
          main="Marxan summed solutions\nRatio: sppFrac/optCostFrac vs. optCostFrac", 
          xlab="Solution cost as fraction of optimal cost", 
          ylab="Fraction of spp meeting target / fraction of optimal cost")
    #lines (suppressWarnings (loess (frac_of_all_spp_meeting_their_target ~ optimal_frac_cost)))    #  good fit
    abline (v=1, lty=6)
    abline (h=1.0, lty=6)
    dev.off()
    }

#===============================================================================

    #  Read various marxan outputs into this program.
        #  Should include these in the marxan package.
        #  Marxan's best solution.
        #  Marxan's votes for including each planning unit.
    
        #  Marxan output files to read from the Marxan output directory 
        #  (need to look these file names up in the manual):

            #  output_best.csv
            #  output_mvbest.csv

            #  output_ssoln.csv
            #  output_solutionsmatrix.csv
            #  output_sum.csv

            #  output_penalty_planning_units.csv
            #  output_penalty.csv

            #  output_sen.dat

#marxan_output_dir_path = parameters$marxan_output_dir    #  "/Users/bill/D/Marxan/output/"  #  replaced in yaml file
marxan_output_dir_path = paste0 (marxan_output_dir, .Platform$file.sep)

marxan_output_best_file_name = "output_best.csv"
marxan_output_ssoln_file_name = "output_ssoln.csv"
marxan_output_mvbest_file_name = "output_mvbest.csv"


    #  Make sure both are sorted in increasing order of planning unit ID.
    #  "arrange()" syntax taken from Wickham comment in:
    #  http://stackoverflow.com/questions/1296646/how-to-sort-a-dataframe-by-columns-in-r

library (plyr)      #  for arrange()

#---------------------------------

    #  2015 05 15 - BTL 
    #  The marxan mailing list digest has had some entries in the last few 
    #  days saying that the *nix version of marxan does not always return 
    #  its best vector in the vector it has labelled as the best.  
    #  So, I need to change this to go through all of the vectors marxan 
    #  generates and figure out which one is the best myself.

marxan_best_df_unsorted_without_missing_rows = 
    read.csv (paste (marxan_output_dir_path, marxan_output_best_file_name, sep=''), 
              header=TRUE)

marxan_best_df_unsorted = 
    add_missing_PUs_to_marxan_solutions (marxan_best_df_unsorted_without_missing_rows,
                                         all_correct_node_IDs, 
                                         "PUID", "SOLUTION")

if (DEBUG_LEVEL > 0)
    {
    cat ("\n\nAfter loading output_best.csv")
    cat ("\nmarxan_best_df_unsorted_without_missing_rows =")
    print (marxan_best_df_unsorted_without_missing_rows)
    cat ("\nmarxan_best_df_unsorted =")
    print (marxan_best_df_unsorted)
    }

marxan_best_df_sorted = arrange (marxan_best_df_unsorted, PUID)

if (DEBUG_LEVEL > 0)
    {
    cat ("\n\nAfter sorting, marxan_best_df_sorted = \n")
    print (marxan_best_df_sorted)
    cat ("\n\n-------------------")
    }

app_optimum_cost = sum (marxan_best_df_sorted$SOLUTION)

#---------------------------------

marxan_mvbest_df = 
    read.csv (paste (marxan_output_dir_path, marxan_output_mvbest_file_name, sep=''), 
              header=TRUE)

if (DEBUG_LEVEL > 0)
    {
    cat ("\n\nAfter loading output_mvbest.csv, marxan_mvbest_df =")
    print (marxan_mvbest_df)
    }

    #  The call to "arrange()" below gives a weird error when run on the 
    #  data frame because the column names have spaces in them (e.g., 
    #  "Conservation Feature").  Renaming them seems to fix the problem
names (marxan_mvbest_df) = 
    c ("ConservationFeature", 
       "FeatureName",
       "Target",
       "AmountHeld",
       "OccurrenceTarget",
       "OccurrencesHeld",
       "SeparationTarget",
       "SeparationAchieved",
       "TargetMet",
       "MPM"  
       )

marxan_mvbest_df = arrange (marxan_mvbest_df, ConservationFeature)

if (DEBUG_LEVEL > 0)
    {
    cat ("\n\nAfter sorting, marxan_mvbest_df = \n")
    print (marxan_mvbest_df)
    cat ("\n\n-------------------")
    }

#---------------------------------

    #  Load the summed solutions vector.
    #  For each PU ID, it shows the number of solution vectors that 
    #  included that PU in the solution.

marxan_ssoln_df_unsorted_without_missing_rows = 
    read.csv (paste (marxan_output_dir_path, marxan_output_ssoln_file_name, sep=''),
              header=TRUE)

marxan_ssoln_df_unsorted = 
    add_missing_PUs_to_marxan_solutions (marxan_ssoln_df_unsorted_without_missing_rows,
                                         all_correct_node_IDs, 
                                         "planning_unit", "number")
    
if (DEBUG_LEVEL > 0)
    {
    cat ("\n\nAfter loading output_best.csv")
    cat ("\nmarxan_ssoln_df_without_missing_rows =")
    print (marxan_ssoln_df_without_missing_rows)
    cat ("\nmarxan_ssoln_df_unsorted =")
    print (marxan_ssoln_df_unsorted)
    }

marxan_ssoln_df = arrange (marxan_ssoln_df_unsorted, planning_unit)

if (DEBUG_LEVEL > 0)
    {
    cat ("\n\nAfter sorting, marxan_ssoln_df = \n")
    print (marxan_ssoln_df)
    cat ("\n\n-------------------")
    }

#---------------------------------

    #  Evaluate apparent summed solutions as a function of the correct 
    #  problem structure and the apparent problem structure, i.e.,
    #  how marxan is really doing vs. how marxan thinks it's doing.

    #  Using correct scores...
plot_incremental_marxan_summed_solution_representations (marxan_ssoln_df, 
                                                          PU_costs, 
                                                    cor_optimum_cost, 
                                                    cor_bpm, 
                                                    "cor", 
                                                          num_spp, 
                                                          plot_output_dir, 
                                                          DEBUG_LEVEL) 

    #  Using apparent scores...
plot_incremental_marxan_summed_solution_representations (marxan_ssoln_df, 
                                                          PU_costs, 
                                                    app_optimum_cost, 
                                                    bpm, 
                                                    "app", 
                                                          num_spp, 
                                                          plot_output_dir, 
                                                          DEBUG_LEVEL) 

#===============================================================================

