#===============================================================================

                #  gscp_9b_convert_Xu_graph_to_spp_PU_problem.R

#===============================================================================

source (paste0 (sourceCodeLocationWithSlash, "gscp_10a_clean_up_completed_graph_structures.R"))
source (paste0 (sourceCodeLocationWithSlash, "gscp_10b_compute_solution_rep_levels_and_costs.R"))
source (paste0 (sourceCodeLocationWithSlash, "gscp_10c_build_adj_and_cooccurrence_matrices.R"))
source (paste0 (sourceCodeLocationWithSlash, "gscp_11_summarize_and_plot_graph_structure_information.R"))

#===============================================================================

timepoints_df = 
    timepoint (timepoints_df, "gscp_10", 
               "Starting gscp_10_clean_up_completed_graph_structures.R")

PU_spp_pair_indices_triple = create_PU_spp_pair_indices (edge_list) 

PU_spp_pair_indices = PU_spp_pair_indices_triple$PU_spp_pair_indices 
PU_col_name = PU_spp_pair_indices_triple$PU_col_name
spp_col_name = PU_spp_pair_indices_triple$spp_col_name

#-------------------------------------------------------------------------------

PU_spp_pair_names_triple = create_PU_spp_pair_names (get_num_PUs (nodes), 
                                                      get_num_spp (edge_list), 
                                                      PU_spp_pair_indices, 
                                                      PU_col_name, 
                                                      spp_col_name
                                                      ) 

PU_spp_pair_names = PU_spp_pair_names_triple$PU_spp_pair_names
PU_vertex_names = PU_spp_pair_names_triple$PU_vertex_names
spp_vertex_names = PU_spp_pair_names_triple$spp_vertex_names

#-------------------------------------------------------------------------------

timepoints_df = 
    timepoint (timepoints_df, "gscp_10c", 
               "Starting gscp_10c_build_adj_and_cooccurrence_matrices.R")

bpm = 
    create_adj_matrix_with_spp_rows_vs_PU_cols (get_num_spp (edge_list),                                                 
                                                get_num_PUs (nodes), 
                                                spp_vertex_names, 
                                                PU_vertex_names, 
                                                PU_spp_pair_indices, 
                                                edge_idx, 
                                                spp_col_name, 
                                                PU_col_name, 
                                                get_dependent_node_IDs (nodes), 
                        ERROR_STATUS_optimal_solution_is_not_optimal, 
                                                emulatingTzar) 

#-------------------------------------------------------------------------------

timepoints_df = 
    timepoint (timepoints_df, "gscp_11", 
               "Starting gscp_11_summarize_and_plot_graph_structure_information.R")

final_link_counts_for_each_node = count (PU_spp_pair_indices, vars=PU_col_name)
final_node_counts_for_each_link = count (PU_spp_pair_indices, vars=spp_col_name)

plot_degree_and_abundance_dists_for_node_graph (final_link_counts_for_each_node, 
                                                final_node_counts_for_each_link,  
                                                PU_col_name, 
                                                plot_output_dir, 
                                                spp_col_name
                                                ) 

#===============================================================================

