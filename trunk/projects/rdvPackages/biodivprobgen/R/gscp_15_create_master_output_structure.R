#===============================================================================

                #  gscp_15_create_master_output_structure.R

#===============================================================================

timepoints_df = 
    timepoint (timepoints_df, "gscp_15", 
               "Starting gscp_15_create_master_output_structure.R")

#===============================================================================

#  Build a master table containing:
    #  planning unit ID
            #  marxan_best_df_sorted$PUID
    #  correct (optimal) answer (as boolean flags on sorted planning units)
    #  best marxan guess
            #  marxan_best_df_sorted$SOLUTION
    #  marxan number of votes for each puid
            #  marxan_ssoln_df$number
    #  difference between correct and best (i.e., (cor - best), FP, FN, etc)
    #  absolute value of difference (to make counting them easier)
    #  number of species on each patch (i.e., simple richness)

#  Need to bind together:
#   problem setup
#       - planning unit IDs (goes with all of these, even if they're split 
#         into separate tables)
#       - number of species (simple richness) on patch as counts
#   correct/optimal solution
#       - correct/optimal solution as 0/1
#   marxan solution(s)
#       - marxan best solution as 0/1
#       - marxan solution votes as counts
#   performance measure(s)
#       - difference between marxan best and optimal solution to represent 
#         error direction (e.g., FP, FN, etc.)
#       - abs (difference) to represent error or no error

    #  *** Need to be sure that the puid column matches in the nodes data frame 
    #  and the marxan data frames.  Otherwise, there could be a mismatch in 
    #  the assignments for inclusion or exclusion of patches in the solutions.

    #  Create table holding all the information to compare solutions.

#===============================================================================

#-------------------------------------------------------------------------------
#      Initialize the data frame holding correct and apparent solutions.
#-------------------------------------------------------------------------------

    #---------------------------------------------------------------------
    #  Need to separate the case of reading a Xu problem from one of his 
    #  his benchmark files vs. generating a problem from scratch.
    #  When you read it from a benchmark file, the correct solution cost 
    #  is known, but not the correct solution vector.
    #  So, when reading a problem from a benchmark file, initialize all 
    #  kinds of things to NA.
    #---------------------------------------------------------------------

if (read_Xu_problem_from_file)
    {
    cor_solution_vector = rep (NA, num_PUs)
    cor_signed_difference = rep (NA, num_PUs)
    cor_abs_val_signed_difference = rep (NA, num_PUs)

            #  Xu options
    n__num_groups = NA
    alpha__ = NA
    p__prop_of_links_between_groups = NA
    r__density = NA
    
        #  Derived Xu options
    num_nodes_per_group = NA
    tot_num_nodes = num_PUs
    num_independent_set_nodes = tot_num_nodes - cor_optimum_cost
    num_dependent_set_nodes = cor_optimum_cost
    num_rounds_of_linking_between_groups = NA
    target_num_links_between_2_groups_per_round = NA
    num_links_within_one_group = NA
    tot_num_links_inside_groups = NA
    max_possible_num_links_between_groups = NA
    max_possible_tot_num_links = NA
    
    opt_solution_as_frac_of_tot_num_nodes = cor_optimum_cost / tot_num_nodes
    
    } else  #  generated the problem
    {
    cor_solution_vector = nodes$dependent_set_member
    cor_signed_difference = marxan_best_df_sorted$SOLUTION - nodes$dependent_set_member
    cor_abs_val_signed_difference = abs (cor_signed_difference)
    }

solutions_df = data.frame (puid = marxan_best_df_sorted$PUID,
                           optimal_solution = cor_solution_vector, 
                           marxan_best_solution = marxan_best_df_sorted$SOLUTION, #  assumes already sorted by PU_ID
                           marxan_votes = marxan_ssoln_df$number, 
                           cor_signed_diff = cor_signed_difference, 
                           cor_abs_val_diff = cor_abs_val_signed_difference, 
                           cor_num_spp_on_patch = final_link_counts_for_each_node$freq
                           )

cor_num_patches_in_solution = sum (solutions_df$optimal_solution)
    #cor_num_patches_in_solution = cor_optimum_cost    #  assuming cost = number of patches
    cat ("\n\ncor_num_patches_in_solution =", cor_num_patches_in_solution)

    #  Will probably get rid of this soon, but want it to run right now.
    #  BTL - 2015 05 09
if (TRUE)
    {
    cat ("\n\n----->  ARE ALL COLUMNS OF solutions_df THE SAME LENGTH?  <-----\n")
    cat ("\nlength (puid) = ", length (solutions_df$puid))
    cat ("\nlength (optimal_solution) = ", length (solutions_df$optimal_solution))
    cat ("\nlength (marxan_best_solution) = ", length (solutions_df$marxan_best_solution))
    cat ("\nlength (marxan_votes) = ", length (solutions_df$marxan_votes))
    cat ("\nlength (cor_signed_diff) = ", length (solutions_df$cor_signed_diff))
    cat ("\nlength (cor_abs_val_diff) = ", length (solutions_df$cor_abs_val_diff))
    cat ("\nlength (cor_num_spp_on_patch) = ", length (solutions_df$cor_num_spp_on_patch))
    cat ("\n\n----->  END OF COLUMN LENGTHS  <-----\n")
    }  

#---------------------------------------------------------------------------
#               Summarize marxan solution features.
#---------------------------------------------------------------------------

marxan_best_solution_PU_IDs = which (marxan_best_df_sorted$SOLUTION > 0)
marxan_best_num_patches_in_solution = length (marxan_best_solution_PU_IDs)
    cat ("\nmarxan_best_num_patches_in_solution =", marxan_best_num_patches_in_solution)

    #  Compute marxan costs.
    #  Assumes equal cost for all patches, i.e., cost per patch = 1.
marxan_best_solution_cost_err_frac = (marxan_best_num_patches_in_solution - cor_num_patches_in_solution) / cor_num_patches_in_solution
abs_marxan_best_solution_cost_err_frac = abs (marxan_best_solution_cost_err_frac)
    cat ("\nmarxan_best_solution_cost_err_frac =", marxan_best_solution_cost_err_frac)
    cat ("\nabs_marxan_best_solution_cost_err_frac =", abs_marxan_best_solution_cost_err_frac)

#---------------------------------------------------------------------------
#       Compute correct and apparent scores for marxan solution.
#---------------------------------------------------------------------------

    #  Apparent scores...
app_marxan_best_solution_NUM_spp_covered = sum (marxan_mvbest_df$MPM)
app_marxan_best_solution_FRAC_spp_covered = app_marxan_best_solution_NUM_spp_covered / num_spp
app_marxan_best_spp_rep_shortfall = 1 - app_marxan_best_solution_FRAC_spp_covered
    cat ("\n\nnum_spp =", num_spp)
    cat ("\n\nlength (app_marxan_best_solution_unmet_spp_rep_frac_indices) = ", 
         length (app_marxan_best_solution_unmet_spp_rep_frac_indices))
    cat ("\n\napp_marxan_best_solution_NUM_spp_covered =", app_marxan_best_solution_NUM_spp_covered)
    cat ("\napp_marxan_best_solution_FRAC_spp_covered =", app_marxan_best_solution_FRAC_spp_covered)
    cat ("\napp_marxan_best_spp_rep_shortfall =", app_marxan_best_spp_rep_shortfall)

    #  Correct scores...
spp_rep_targets = rep (1, num_spp)    #  Seems like this should already have been set long before now.
marxan_best_solution_spp_rep_fracs = 
    compute_rep_fraction (cor_bpm, marxan_best_solution_PU_IDs, DEBUG_LEVEL, spp_rep_targets)
cor_marxan_best_solution_unmet_spp_rep_frac_indices = which (marxan_best_solution_spp_rep_fracs < 1)

cor_marxan_best_solution_NUM_spp_covered = num_spp - length (cor_marxan_best_solution_unmet_spp_rep_frac_indices)
cor_marxan_best_solution_FRAC_spp_covered = cor_marxan_best_solution_NUM_spp_covered / num_spp
cor_marxan_best_spp_rep_shortfall = 1 - cor_marxan_best_solution_FRAC_spp_covered
    cat ("\n\nlength (cor_marxan_best_solution_unmet_spp_rep_frac_indices) = ", 
         length (cor_marxan_best_solution_unmet_spp_rep_frac_indices))
    cat ("\n\ncor_marxan_best_solution_NUM_spp_covered =", cor_marxan_best_solution_NUM_spp_covered)
    cat ("\ncor_marxan_best_solution_FRAC_spp_covered =", cor_marxan_best_solution_FRAC_spp_covered)
    cat ("\ncor_marxan_best_spp_rep_shortfall =", cor_marxan_best_spp_rep_shortfall)

#===============================================================================

#  Supporting data not in binding
#   species vs planning units (database?) to allow computation of performance 
#   measures related to which species are covered in solutions
#   (e.g., SELECT species WHERE planning unit ID == curPlanningUnitID)
#   (e.g., SELECT planning unit ID WHERE species == curSpeciesID))
#       - planning unit IDs
#       - set of species on planning unit

#     ALSO STILL NEED TO ADD THE FP AND FN RATES AND OTHER ERROR MODEL 
#     ATTRIBUTES TO THE OUTPUT DATA FRAME AND CSV FILE.

#-------------------------------------------------------------------------------

num_runs = 1    #  Vestigial?  Not sure it will ever be anything but 1.
                #  2015 05 09 - BTL.

results_df = 
    data.frame (runset_abbrev = rep (NA, num_runs), 
                run_ID = rep (NA, num_runs), 
                
                exceeded_thresh_for_num_spp = rep (NA, num_runs), 
                
                num_PUs = rep (NA, num_runs), 
                num_spp = rep (NA, num_runs), 
                num_spp_per_PU = rep (NA, num_runs), 
                seed = rep (NA, num_runs), 
                
                    #  Xu options
                n__num_groups = rep (NA, num_runs), 
                alpha__ = rep (NA, num_runs), 
                p__prop_of_links_between_groups = rep (NA, num_runs), 
                r__density = rep (NA, num_runs),

                    #  Results
                opt_solution_as_frac_of_tot_num_nodes = rep (NA, num_runs),
                cor_num_patches_in_solution = rep (NA, num_runs),
                marxan_best_num_patches_in_solution = rep (NA, num_runs), 
                abs_marxan_best_solution_cost_err_frac = rep (NA, num_runs), 
                marxan_best_solution_cost_err_frac = rep (NA, num_runs), 
                
                cor_marxan_best_spp_rep_shortfall = rep (NA, num_runs),                
                cor_marxan_best_solution_NUM_spp_covered = rep (NA, num_runs), 
                cor_marxan_best_solution_FRAC_spp_covered = rep (NA, num_runs), 
                
                app_marxan_best_spp_rep_shortfall = rep (NA, num_runs),                
                app_marxan_best_solution_NUM_spp_covered = rep (NA, num_runs), 
                app_marxan_best_solution_FRAC_spp_covered = rep (NA, num_runs), 
                
                    #  Error generation parameters
                add_error = rep (NA, num_runs), 
                FP_const_rate = rep (NA, num_runs), 
                FN_const_rate = rep (NA, num_runs), 
                match_error_counts = rep (NA, num_runs), 
                original_FP_const_rate = rep (NA, num_runs), 
                original_FÑ_const_rate = rep (NA, num_runs), 
                
                    #  Derived options
                num_nodes_per_group = rep (NA, num_runs),
                tot_num_nodes = rep (NA, num_runs),
                num_independent_set_nodes = rep (NA, num_runs),
                num_dependent_set_nodes = rep (NA, num_runs),
                num_rounds_of_linking_between_groups = rep (NA, num_runs),
                target_num_links_between_2_groups_per_round = rep (NA, num_runs), 
                num_links_within_one_group = rep (NA, num_runs),
                tot_num_links_inside_groups = rep (NA, num_runs),
                max_possible_num_links_between_groups = rep (NA, num_runs),
                max_possible_tot_num_links = rep (NA, num_runs), 
                
                    #  Marxan options
                marxan_spf_const = rep (NA, num_runs),
                marxan_PROP = rep (NA, num_runs),
                marxan_RANDSEED = rep (NA, num_runs),
                marxan_NUMREPS = rep (NA, num_runs),

                    #  Marxan Annealing Parameters
                marxan_NUMITNS = rep (NA, num_runs),
                marxan_STARTTEMP = rep (NA, num_runs),
                marxan_NUMTEMP = rep (NA, num_runs),

                    #  Marxan Cost Threshold
                marxan_COSTTHRESH = rep (NA, num_runs),
                marxan_THRESHPEN1 = rep (NA, num_runs),
                marxan_THRESHPEN2 = rep (NA, num_runs),

                    #  Marxan Program control
                marxan_RUNMODE = rep (NA, num_runs),
                marxan_MISSLEVEL = rep (NA, num_runs),
                marxan_ITIMPTYPE = rep (NA, num_runs),
                marxan_HEURTYPE = rep (NA, num_runs),
                marxan_CLUMPTYPE = rep (NA, num_runs),
                
                    #  Full runset name
                runset_name = rep (NA, num_runs)
                )

cur_result_row = 0

#-------------------------------------------------------------------------------

cur_result_row = cur_result_row + 1

    #  Filling in the runset_abbrev with the full runset name for the moment, 
    #  because it's more reliably correct since it's automatically captured 
    #  by tzar.  Not sure what I'll do in the long run.
    #  2015 03 09 - BTL
results_df$runset_abbrev [cur_result_row]                                    = parameters$runset_name    #  parameters$runset_abbrev

results_df$exceeded_thresh_for_num_spp                                       = FALSE

results_df$num_PUs [cur_result_row]                                          = num_PUs
results_df$num_spp [cur_result_row]                                          = num_spp
results_df$num_spp_per_PU [cur_result_row]                                   = num_spp / num_PUs
results_df$seed [cur_result_row]                                             = seed

    #  Xu options
results_df$n__num_groups [cur_result_row]                                   = n__num_groups
results_df$alpha__ [cur_result_row]                                          = alpha__
results_df$p__prop_of_links_between_groups [cur_result_row]                 = p__prop_of_links_between_groups
results_df$r__density [cur_result_row]                                       = r__density

    #  Results
results_df$opt_solution_as_frac_of_tot_num_nodes [cur_result_row]            = opt_solution_as_frac_of_tot_num_nodes
results_df$cor_num_patches_in_solution [cur_result_row]                                  = cor_num_patches_in_solution
results_df$marxan_best_num_patches_in_solution [cur_result_row]                          = marxan_best_num_patches_in_solution
results_df$abs_marxan_best_solution_cost_err_frac [cur_result_row]           = abs_marxan_best_solution_cost_err_frac
results_df$marxan_best_solution_cost_err_frac [cur_result_row]               = marxan_best_solution_cost_err_frac

results_df$cor_marxan_best_spp_rep_shortfall [cur_result_row]                                = cor_marxan_best_spp_rep_shortfall                
results_df$cor_marxan_best_solution_NUM_spp_covered [cur_result_row]             = cor_marxan_best_solution_NUM_spp_covered
results_df$cor_marxan_best_solution_FRAC_spp_covered [cur_result_row]            = cor_marxan_best_solution_FRAC_spp_covered

results_df$app_marxan_best_spp_rep_shortfall [cur_result_row]                                = app_marxan_best_spp_rep_shortfall                
results_df$app_marxan_best_solution_NUM_spp_covered [cur_result_row]             = app_marxan_best_solution_NUM_spp_covered
results_df$app_marxan_best_solution_FRAC_spp_covered [cur_result_row]            = app_marxan_best_solution_FRAC_spp_covered

    #  Error generation parameters
results_df$add_error [cur_result_row]                                       = add_error
results_df$FP_const_rate [cur_result_row]                                   = FP_const_rate
results_df$FN_const_rate [cur_result_row]                                   = FN_const_rate
results_df$match_error_counts [cur_result_row]                              = match_error_counts
results_df$original_FP_const_rate [cur_result_row]                          = original_FP_const_rate
results_df$original_FÑ_const_rate [cur_result_row]                          = original_FÑ_const_rate
                
    #  Derived Xu options
results_df$num_nodes_per_group [cur_result_row]                             = num_nodes_per_group
results_df$tot_num_nodes [cur_result_row]                                    = tot_num_nodes
results_df$num_independent_set_nodes [cur_result_row]                        = num_independent_set_nodes
results_df$num_dependent_set_nodes [cur_result_row]                          = num_dependent_set_nodes
results_df$num_rounds_of_linking_between_groups [cur_result_row]            = num_rounds_of_linking_between_groups
results_df$target_num_links_between_2_groups_per_round [cur_result_row]     = target_num_links_between_2_groups_per_round
results_df$num_links_within_one_group [cur_result_row]                      = num_links_within_one_group
results_df$tot_num_links_inside_groups [cur_result_row]                     = tot_num_links_inside_groups
results_df$max_possible_num_links_between_groups [cur_result_row]           = max_possible_num_links_between_groups
results_df$max_possible_tot_num_links [cur_result_row]                       = max_possible_tot_num_links

    #  Marxan options
results_df$marxan_spf_const [cur_result_row]                                 = spf_const
results_df$marxan_PROP [cur_result_row]                                      = marxan_PROP
results_df$marxan_RANDSEED [cur_result_row]                                  = marxan_RANDSEED
results_df$marxan_NUMREPS [cur_result_row]                                   = marxan_NUMREPS

    #  Marxan Annealing Parameters
results_df$marxan_NUMITNS [cur_result_row]                                   = marxan_NUMITNS
results_df$marxan_STARTTEMP [cur_result_row]                                 = marxan_STARTTEMP
results_df$marxan_NUMTEMP [cur_result_row]                                   = marxan_NUMTEMP

    #  Marxan Cost Threshold
results_df$marxan_COSTTHRESH [cur_result_row]                                = marxan_COSTTHRESH
results_df$marxan_THRESHPEN1 [cur_result_row]                                = marxan_THRESHPEN1
results_df$marxan_THRESHPEN2 [cur_result_row]                                = marxan_THRESHPEN2

    #  Marxan Program control
results_df$marxan_RUNMODE [cur_result_row]                                   = marxan_RUNMODE
results_df$marxan_MISSLEVEL [cur_result_row]                                 = marxan_MISSLEVEL
results_df$marxan_ITIMPTYPE [cur_result_row]                                 = marxan_ITIMPTYPE
results_df$marxan_HEURTYPE [cur_result_row]                                  = marxan_HEURTYPE
results_df$marxan_CLUMPTYPE [cur_result_row]                                 = marxan_CLUMPTYPE
                
    #  Full runset name
results_df$runset_name [cur_result_row]                                      = parameters$runset_name



#  Getting an error.  Not sure why...  Is it because the free variable names 
#  like num_PUs, are the same as the list element names, like results_df$num_PUs?
#
#  Error in `$<-.data.frame`(`*tmp*`, "num_PUs", value = c(NA, 12L)) :  
#    replacement has 2 rows, data has 1 
#  Calls: source ... withVisible -> eval -> eval -> $<- -> $<-.data.frame 
#  Execution halted 


if (parameters$compute_network_metrics)
    {
        #  Need to bind the network measures to the data frame too.
    results_df = cbind (results_df, 
                        bipartite_metrics_from_bipartite_package, 
                        bipartite_metrics_from_igraph_package_df
                        )
    }

write_results_to_files (results_df, parameters)

#===============================================================================

