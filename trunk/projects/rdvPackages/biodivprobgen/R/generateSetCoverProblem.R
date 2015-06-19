#===============================================================================

                        #  generateSetCoverProblem.R

#===============================================================================

#  *** Future code should include test routines.  Would be good if those  
#  routines could be explicit tests of the assumptions (and conclusions?) of  
#  the 4 cases in the proof.

#===============================================================================

#  Procedure to run a single test case EMULATING tzar:

#   - Duplicate single_test.yaml into project.yaml.

#   - Set the tzar emulation flags wherever necessary.
#       In emulatingTzarFlag.R, set:
#           emulatingTzar = TRUE
#       In this file (generateSetCoverProblem.R), set:
#           running_tzar_or_tzar_emulator = TRUE
#       However, for nearly everything that _I_ am doing, that flag will never 
#       change since I'm nearly always using tzar.  It would be more of an 
#       issue for someone else who is not using tzar.

#           IS THIS STEP RIGHT?  DOES IT MATTER?  NOT SURE...
#   - Make sure current working directory is:    
#       /Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R
#     e,g, 
#       setwd ("/Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R")

#   - Source this file (generateSetCoverProblem.R)
#       Under RStudio, that just means having this file open in the 
#       edit window and hitting the Source button.
#       
#   - Just to give a ballpark estimate of how long to expect the test to run, 
#     as the code and yaml file stand right now (2015 01 26 4:40 pm) took about 
#     1 minute 45 seconds to run on my MacBook Pro with much of the memory 
#     and disk unavailable and a backup copying process going on 
#     in the background. 

#  NOTE that the choice of random seed in the yaml file is important 
#  because the example creates a test problem based on drawing the control 
#  parameters from a random distribution.  When the seed was 111, the 
#  test crashed with the message below.  When I changed it to 701, it 
#  ran to completion.
#       Failing:  max_possible_tot_num_links ( 3291 ) > maximum allowed ( 2000 ).
#       Save workspace image to ~/D/rdv-framework/projects/rdvPackages/biodivprobgen/.RData? [y/n/c]: 
#  However, the fail was just what it was supposed to do when those 
#  parameters came up, so the yaml file could be changed to use 111 
#  instead of 701 if you want to induce a crash to test that error 
#  trapping.
    
#-------------------------------------------------------------------------------

#  Procedure to run a single test case USING tzar:

#   - Same as above, except:

#   - Set the emulatingTzar flag to FALSE, i.e., 
#       In emulatingTzarFlag.R, set:
#           emulatingTzar = FALSE

#   - In a terminal window, Make sure current working directory is not where 
#     the source code is, but rather, in a terminal window, cd to where the 
#     tzar jar is:    
#       /Users/bill/D/rdv-framework

#   - Instead of sourcing this R file, run the following command in the 
#     terminal window:
#           To put results in the tzar default area
#       java -jar tzar.jar execlocalruns /Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R/
#   OR
#           To use a specially named tzar area for the test
#       java -jar tzar.jar execlocalruns /Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R/ --runset=single_test_unifRand_p_r_n_a_seed_701_in_phase_transition_area
#       
#   - Just to give a ballpark estimate of how long to expect the test to run, 
#     as the code and yaml file stand right now (2015 01 26 4:40 pm) took about 
#     1 minute 15 or 20 seconds to run on my MacBook Pro with much of the  
#     memory and disk unavailable but no backup copying process going on 
#     in the background. 

#===============================================================================

#  History:

#  v1 - 
#  v2 - 
#  v3 - add degree distribution calculations
#  v4 - cleaning up code layout formatting
#  v5 - replacing node_link_pairs with link_node_pairs to match marxan puvspr

#  2014 12 10 - BTL
#       Starting to replace the data frames and methods for operating on them 
#       so that it's mostly done with sqlite.  It should make the code clearer 
#       and make it easy to keep the whole structure in files in the tzar 
#       output directory for each run.  This, in turn, will make it much 
#       easier to go back and do post-hoc operations on the graph and output 
#       data after the run.  Currently, as the experiments evolve, I keep 
#       finding that I want to do things that I had not foreseen and I need 
#       access to the data without re-running the whole set of experiments.
#
#       Before making the big changes, I've removed the huge block of notes 
#       and code that I had at the end of the file that were related to 
#       marxan and things I need to do.  I cut all of that out and pasted it 
#       into another R file called:
#           /Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R/
#               oldCommentedMarxanNotesCodeRemovedFrom_generateSetCoverProblem_2014_12_10.R

#  2014 12 11 - BTL
#       - Replacing all references to "group" with "group", since I'm going to 
#           add the ability to have more than one independent node per group.   
#           These groups will no longer be groups if there is more than one 
#           independent node because by definition, no independent nodes can 
#           be linked.  There will still be a group inside the group, i.e., the 
#           dependent nodes, and the independent nodes will still link to those 
#           dependent nodes.  They just won't link to each other.  
#           Renaming also means that I need to change the names of a couple of 
#           variables in the yaml file who have "clique" in their name.
#
#       - Converted choice of integerize() function from hard-coded value to 
#           switch statement based on option given in yaml file.

#  2014 12 25 - BTL
#       - Split long original file into 17 source files and sourced them 
#         since the file had gotten unmanageable to work on and understand.

#  2014 12 28 - BTL
#       - Changed all source() calls to use the full path name since the 
#         source files weren't being found.  I think that tzar had the 
#         current directory set to biodivprobgen but the source is all in 
#         biodivprobgen/R.
#       - Revised all of the tzar emulation code since it wasn't working.  
#         Much of this was due to River having introduced the "metadata/" 
#         subdirectory into the tzar output directory structure and putting 
#         the parameters.R file in there instead of in the output directory 
#         itself.

#  2014 12 29 - BTL
#       - Moved both tzar control flag settings up into this file so that 
#         they are easier to find and control in one place.  I'm still 
#         leaving the actual setting of emulatingTzar in the file called 
#         emulatingTzarFlag.R for the reasons explained below, but I'm 
#         sourcing that file from here instead of in gscp_2_tzar_emulation.R 
#         because I couldn't remember where it was happening when I wanted 
#         to change it between runs.

#  2015 04 27 - BTL
#       - Extracted initialization code into biodivprobgen_initialization.R.
#       - Extracted utility functions into biodivprobgen_utilities.R.

#===============================================================================
#           Specify the directory where code is to be sourced from.
#===============================================================================

    #  Need to do this in a better way so that it is appropriate for  
    #  anybody's setup.
if (!exists ("sourceCodeLocationWithSlash"))
    sourceCodeLocationWithSlash = 
        "/Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R/"

#===============================================================================
#                   Set up variables, etc. for this run.
#===============================================================================

source (paste0 (sourceCodeLocationWithSlash, "biodivprobgen_initialization.R"))

#===============================================================================
#       Generate a problem, i.e, create the Xu graph nodes and edge_list.
#===============================================================================

PU_spp_pair_indices_sextet = NULL
correct_solution_vector_is_known = FALSE
read_Xu_problem_from_file = parameters$read_Xu_problem_from_file

if (read_Xu_problem_from_file)
{
    #  
    infile_name = parameters$Xu_problem_input_file_name

    PU_spp_pair_indices_sextet = 
        load_Xu_problem_from_file_into_PU_spp_pair_indices_sextet (infile_name, 
                                        parameters$given_correct_solution_cost) 

    dependent_node_IDs = NULL
    
} else

#     PU_spp_pair_indices = PU_spp_pair_indices_sextet$PU_spp_pair_indices 
#     PU_col_name = PU_spp_pair_indices_sextet$PU_col_name
#     spp_col_name = PU_spp_pair_indices_sextet$spp_col_name
#     num_PUs = PU_spp_pair_indices_sextet$num_PUs
#     num_spp = PU_spp_pair_indices_sextet$num_spp
#     correct_solution_cost = PU_spp_pair_indices_sextet$correct_solution_cost

#-------------------------------------------------------------------------------

{
#  Not a function.  Not sure how to make this a function yet...
source (paste0 (sourceCodeLocationWithSlash, "gscp_5_derive_control_parameters.R"))

#-------------------------------------------------------------------------------

    #  Create and load nodes data structure.
nodes = create_nodes_data_structure (tot_num_nodes, 
                                      num_nodes_per_group, 
                                      n__num_groups, 
                                      num_independent_nodes_per_group 
                                     )
correct_solution_vector_is_known = TRUE
dependent_node_IDs = get_dependent_node_IDs (nodes)
num_PUs = get_num_nodes (nodes)
PU_costs = get_PU_costs (num_PUs)

#-------------------------------------------------------------------------------

    #  Create and load edge_list data structure.

edge_list = 
    create_Xu_graph (num_nodes_per_group, 
                     n__num_groups, 
                     nodes, 
                     max_possible_tot_num_links, 
                     target_num_links_between_2_groups_per_round, 
                     num_rounds_of_linking_between_groups, 
                     DEBUG_LEVEL
                     )

#-------------------------------------------------------------------------------

    #  Combine the information in the nodes and edge_list data structures into 
    #  a single data structure that has one line for each species on each 
    #  planning unit.

timepoints_df = 
    timepoint (timepoints_df, "gscp_10", 
               "Starting gscp_10_clean_up_completed_graph_structures.R")

PU_spp_pair_indices_sextet = create_PU_spp_pair_indices (edge_list, 
                                                          nodes, 
                                                          dependent_node_IDs, 
                                                          PU_costs, 
                                                         num_PUs) 
}

#-------------------------------------------------------------------------------

PU_spp_pair_indices  = PU_spp_pair_indices_sextet$PU_spp_pair_indices 
PU_col_name          = PU_spp_pair_indices_sextet$PU_col_name
spp_col_name         = PU_spp_pair_indices_sextet$spp_col_name
num_PUs              = PU_spp_pair_indices_sextet$num_PUs
num_spp              = PU_spp_pair_indices_sextet$num_spp
cor_optimum_cost     = PU_spp_pair_indices_sextet$correct_solution_cost
    
#===============================================================================

    #  Having problems with problem dimensions on some runs being too big and  
    #  forcing problems that are much larger than are relevant for biodiversity 
    #  or that just take too long to run in the current experimental setting.  
    #  For example, things can run for 6 or more hours when I want them to 
    #  be taking on the order of minutes instead of hours.  I may eventually 
    #  want to go ahead with these kinds of big runs, but for now, I want to 
    #  cut them down to be no larger than the biggest number of species 
    #  that I'm aware of in biodiversity problems.  At the moment, the 
    #  biggest ones that I know of have done around 2000 species but I'm 
    #  going to make this threshold be an input variable.  
    #  The number of planning units has not been a problem yet since they 
    #  have been far less than the number of species.  They're also easier 
    #  to control through the choice of the number of groups, etc.  
        #  The Xu benchmark problems are much bigger than typical reserve 
        #  selection problems, so limiting the number of species would not 
        #  allow any of them to run.
        #  I'm going to override the whatever max has been set in the 
        #  yaml file or elsewhere so that I can be sure that the Xu 
        #  benchmarks will be run when requested.

if (read_Xu_problem_from_file)
    {
    max_allowed_num_spp = num_spp
    
        #  Also need to create costs, but hadn't decoded the num_PUs until 
        #  just before now.
    PU_costs = get_PU_costs (num_PUs)

    } else
    {
    max_allowed_num_spp = parameters$max_allowed_num_spp
    }

if (num_spp > max_allowed_num_spp)
    {
    cat ("\n\nQuitting:  num_spp (", num_spp, ") > maximum allowed (", 
         parameters$max_allowed_num_spp, ").\n\n")

    cur_result_row = 1
    
    write_abbreviated_results_to_files (cur_result_row,                                         
                                          parameters, 
                                          num_PUs, 
                                          num_spp, 
                                          seed, 
                                          n__num_groups, 
                                          alpha__, 
                                          p__prop_of_links_between_groups, 
                                          r__density, 
                                          num_nodes_per_group, 
                                          tot_num_nodes, 
                                          num_independent_set_nodes, 
                                          num_dependent_set_nodes, 
                                          num_rounds_of_linking_between_groups, 
                                          target_num_links_between_2_groups_per_round, 
                                          num_links_within_one_group, 
                                          tot_num_links_inside_groups, 
                                          max_possible_num_links_between_groups, 
                                          max_possible_tot_num_links
                                          ) 
    
    } else  #  A legal number of species
    {
    #===============================================================================
    #   Convert PU/spp data structure into other formats needed downstream.
    #===============================================================================
    
    timepoints_df = 
        timepoint (timepoints_df, "gscp_10c", 
                   "Starting gscp_10c_build_adj_and_cooccurrence_matrices.R")
    
    bpm = 
        create_adj_matrix_with_spp_rows_vs_PU_cols (num_spp,                                                 
                                                    num_PUs, 
## 2015 05 01 ##                                                    spp_vertex_names, 
## 2015 05 01 ##                                                    PU_vertex_names, 
                                                    PU_spp_pair_indices, 
                                                    edge_idx, 
                                                    spp_col_name, 
                                                    PU_col_name, 
                                                    dependent_node_IDs, 
                                                    correct_solution_vector_is_known, 
                            ERROR_STATUS_optimal_solution_is_not_optimal, 
                                                    emulatingTzar) 
    

        #  See if there are any duplicate edges/spp in the problem.
    see_if_there_are_any_duplicate_links (bpm, num_spp)

    #===============================================================================
    #                   Save the values for the correct problem.
    #===============================================================================
    
        #  The problem structures built so far represent the correct values.
        #  Adding error to the problem structure will create an apparent 
        #  problem structure that is probably different from the correct 
        #  structure.
        #  When we compute scores at the end of all this, we need to compute 
        #  them with respect to the correct problem rather than the apparent.
        #  So, before we add error, we need to save the values defining the 
        #  correct structure.

    cor_PU_spp_pair_indices = PU_spp_pair_indices
    cor_bpm = bpm

    #===============================================================================
    #                   Add error to the species occupancy data.
    #===============================================================================
    
    add_error = FALSE   
    if (! is.null (parameters$add_error_to_spp_occupancy_data))
        add_error = parameters$add_error_to_spp_occupancy_data

    if (add_error)
        {
        ret_vals_from_add_errors = 
            add_error_to_spp_occupancy_data (parameters, bpm, 
                                             num_PU_spp_pairs, 
                                             num_PUs, num_spp)

            #  Save the chosen error parameters to output later with results.
        original_FP_const_rate = ret_vals_from_add_errors$original_FP_const_rate
        original_FN_const_rate = ret_vals_from_add_errors$original_FN_const_rate
        match_error_counts = ret_vals_from_add_errors$match_error_counts
        FP_const_rate = ret_vals_from_add_errors$FP_const_rate
        FN_const_rate = ret_vals_from_add_errors$FN_const_rate

# 2015 06 19 - 1 PM
# NEED TO ADD app_ TO THESE 2 VARIABLES AND ALL OF THEIR DOWNSTREAM CONSEQUENCES, 
# INCLUDING OTHER VARIABLES DERIVED FROM THEM.
# Also need to clone the distribution output stuff below so that it's done for 
# both correct and apparent.  Right now, it's only done for apparent.

            #  Set the values for the apparent problem structure.        
        app_PU_spp_pair_indices      = ret_vals_from_add_errors$app_PU_spp_pair_indices
        bpm                      = ret_vals_from_add_errors$app_spp_occupancy_data        
        }

    #===============================================================================
    #                   Summarize and plot graph structure information.
    #===============================================================================
    
    timepoints_df = 
        timepoint (timepoints_df, "gscp_11", 
                   "Starting gscp_11_summarize_and_plot_graph_structure_information.R")
    
#    final_link_counts_for_each_node = count (PU_spp_pair_indices, vars=PU_col_name)

############

final_link_counts_for_each_node_without_missing_rows = count (app_PU_spp_pair_indices, vars=PU_col_name)

all_correct_node_IDs = nodes$node_ID

final_link_counts_for_each_node = 
    add_missing_PUs_to_marxan_solutions (final_link_counts_for_each_node_without_missing_rows,
                                         all_correct_node_IDs, 
                                         "PU_ID", "freq")

if (DEBUG_LEVEL > 0)
    {
    cat ("\n\nAfter loading output_best.csv")
    cat ("\nfinal_link_counts_for_each_node_without_missing_rows =")
    print (final_link_counts_for_each_node_without_missing_rows)
    cat ("\nfinal_link_counts_for_each_node =")
    print (final_link_counts_for_each_node)
    }

############

        #####  DOES THIS NEED THE SAME FIX AS FOR THE NODES?  #####
#It's only used here and in gscp_11, so maybe not?

    final_node_counts_for_each_link = count (app_PU_spp_pair_indices, vars=spp_col_name)
    
    plot_degree_and_abundance_dists_for_node_graph (final_link_counts_for_each_node, 
                                                    final_node_counts_for_each_link,  
                                                    PU_col_name, 
                                                    plot_output_dir, 
                                                    spp_col_name
                                                    ) 
    
    #===============================================================================
    #           Generate the data structure with names instead of indices.
    #===============================================================================
    
    PU_spp_pair_names_triple = create_PU_spp_pair_names (num_PUs, 
                                                          num_spp, 
                                                          app_PU_spp_pair_indices, 
                                                          PU_col_name, 
                                                          spp_col_name
                                                          ) 
    
    PU_spp_pair_names = PU_spp_pair_names_triple$PU_spp_pair_names
    PU_vertex_names = PU_spp_pair_names_triple$PU_vertex_names
    spp_vertex_names = PU_spp_pair_names_triple$spp_vertex_names

    #===============================================================================
    #                       Compute network metrics.
    #===============================================================================
    
    if (parameters$compute_network_metrics)
        {
        timepoints_df = 
            timepoint (timepoints_df, "gscp_11a", 
                       "Starting gscp_11a_network_measures_using_bipartite_package.R")

        bipartite_metrics_from_bipartite_package = 
            compute_network_measures_using_bipartite_package (bpm) 

        timepoints_df = 
            timepoint (timepoints_df, "gscp_11b", 
                       "Starting gscp_11b_network_measures_using_igraph_package.R")

        source (paste0 (sourceCodeLocationWithSlash, "gscp_11b_network_measures_using_igraph_package.R"))
        }
    
    #===============================================================================
    #                                   Run marxan.
    #===============================================================================

    timepoints_df = 
        timepoint (timepoints_df, "gscp_12", 
                   "Starting gscp_12_write_network_to_marxan_files.R")
    
    spf_const = write_network_to_marxan_files (app_PU_spp_pair_indices,
                                                  PU_col_name, 
                                                  spp_col_name, 
                                                  parameters, 
                                                  num_spp, 
                                                  PU_IDs, 
                                                  spp_IDs, 
                                                  marxan_input_dir, 
                                                  marxan_output_dir
                                                  ) 

    #---------------------------------------------------------------------------
    
    source (paste0 (sourceCodeLocationWithSlash, "gscp_13_write_marxan_control_file_and_run_marxan.R"))
    
    #---------------------------------------------------------------------------

    source (paste0 (sourceCodeLocationWithSlash, "gscp_14_read_marxan_output_files.R"))
    
    #===============================================================================
    #                   Dump all of the different kinds of results.
    #===============================================================================
    
    source (paste0 (sourceCodeLocationWithSlash, "gscp_15_create_master_output_structure.R"))
    
    }

#===============================================================================
#                                   Clean up.
#===============================================================================

source (paste0 (sourceCodeLocationWithSlash, "gscp_16_clean_up_run.R"))

#-------------------------------------------------------------------------------

    #  Writing the timepoints output file has to come BEFORE the tzar 
    #  emulation cleanup because the directory name used to locate the 
    #  output here will be changed by the emulator cleanup.

timepoints_df = timepoint (timepoints_df, "end", "End of run...")
timepoints_df = timepoints_df [1:cur_timepoint_num,]  #  Remove excess NA lines.
write.csv (timepoints_df, 
           file = parameters$timepoints_filename, 
           row.names = FALSE)

#-------------------------------------------------------------------------------

source (paste0 (sourceCodeLocationWithSlash, "gscp_17_clean_up_tzar_emulation.R"))

cat ("\n\nALL DONE at ", date(), "\n\n")

#===============================================================================

