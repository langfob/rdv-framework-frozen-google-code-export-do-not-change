#===============================================================================

                #  gscp_10_clean_up_completed_graph_structures.R

#===============================================================================

library (stringr)

#===============================================================================

    #  All node pairs should be loaded into the edge_list table now 
    #  and there should be no NA lines left in the table.
    
    #  However no duplicate links are allowed, so need to go through all 
    #  node pairs and remove non-unique ones.
                #  BTL - 2015 01 03 - Is this "no duplicates allowed" taken 
                #                       from the original algorithm?  
                #                       Need to be sure about that since 
                #                       it affects things downstream.

        #  NOTE:  I think that this unique() call only works if the 
        #           pairs are ordered within pair, i.e., if all from 
        #           nodes have a value less than or equal to the to value.
        #           That wouldn't be necessary if these were directed links, 
        #           but undirected, you couldn't recognize duplicates if 
        #           the order was allowed to occur both ways, i.e., (3,5) and 
        #           (5,3) would not be flagged as being duplicates.

#===============================================================================

    #  Convert edge list to PU/spp table to give to Marxan and to network 
    #  functions for bipartite networks:
    #
    #  Now that we have the edge list, we need to go through and 
    #  create a table where every link attached to a node appears on a 
    #  separate line of the table and is labelled with the node ID.  
    #  So, that means that we have to go through the whole edge list and 
    #  create 2 new table entries for each link in the edge list.  
    #  Each of those entries gives the ID of one of the end nodes of the 
    #  link plus the link's ID.  
    #
    #  This table needs to be built because it's the form that Marxan expects 
    #  the spp and PU data to be in, i.e., node=PU and link=spp and every 
    #  line in the table is specifying a PU and one of the species in it.  
    #  If we weren't feeding Marxan, there would be no need for this kind 
    #  of a table since we already have an edge list.
    #
    #  However, there is one other useful byproduct of building this table.
    #  It makes it easy to compute rank-abundance information and information 
    #  about the distribution of species across patches.
    #
    #  I just realized that this structure is also something like the 
    #  description of a bipartite network, so I may need to modify or use 
    #  it in doing the bipartite network analyses too.

create_PU_spp_pair_indices = function (edge_list) 
    {
    num_edge_list = get_num_edge_list (edge_list)

    num_PU_spp_pairs = 2 * num_edge_list
    PU_spp_pair_indices = 
        data.frame (PU_ID = rep (NA, num_PU_spp_pairs),
                    spp_ID = rep (NA, num_PU_spp_pairs))
    
    PU_col_name = names (PU_spp_pair_indices)[1]
    spp_col_name = names (PU_spp_pair_indices)[2]
    
    next_PU_spp_pair_row = 1
    
    for (cur_spp_ID in 1:num_edge_list)
        {
        PU_spp_pair_indices [next_PU_spp_pair_row, PU_col_name] = edge_list [cur_spp_ID, 1]  #  smaller_PU_ID
        PU_spp_pair_indices [next_PU_spp_pair_row, spp_col_name] = cur_spp_ID  #  next_spp_ID    
        next_PU_spp_pair_row = next_PU_spp_pair_row + 1    
        
        PU_spp_pair_indices [next_PU_spp_pair_row, PU_col_name] = edge_list [cur_spp_ID, 2]  #  larger_PU_ID
        PU_spp_pair_indices [next_PU_spp_pair_row, spp_col_name] = cur_spp_ID  #  next_spp_ID
        next_PU_spp_pair_row = next_PU_spp_pair_row + 1
        
        }  #  end for - cur_spp_ID
    
    return (list (PU_spp_pair_indices=PU_spp_pair_indices, 
                  PU_col_name=PU_col_name,
                  spp_col_name=spp_col_name))
    }

#===============================================================================

get_num_PUs = function (nodes) { get_num_nodes (nodes) }    #  = tot_num_nodes
get_num_spp = function (edge_list) { get_num_edge_list (edge_list) }

#===============================================================================
#  Create a data frame using NAMES of the elements rather than their INDICES.  
#===============================================================================

    #  Though the two data frames carry identical information, it looks 
    #  like both of them are necessary because different network packages 
    #  expect different inputs.  The bipartite package creates an 
    #  adjacency matrix based on the indices, but the igraph package 
    #  creates a bipartite graph using either the indices or the vertex names.  

    #  However, if I later decide to use the vertex indices, I need to go 
    #  back and renumber either the spp vertices or the PU vertices so 
    #  that they don't overlap the other set.  That may end up being the 
    #  better strategy when graphs get big, but at the moment, giving them 
    #  names seems less likely to introduce some kind of indexing bug.
        
    #  Will create names for PU vertices by prepending the vertex ID with a "p".
    #  Similarly, spp vertices will be named by prepending with an "s".
    #  Note that we have to either uniquely name the vertices or we have to  
    #  renumber either the spp or the PUs.  This is because the numbering of 
    #  both sets of vertices starts at 1 and that means the vertex IDs are 
    #  not unique when the two sets are combined.  

create_PU_spp_pair_names = 
        function (num_PUs, 
                  num_spp, 
                  PU_spp_pair_indices, 
                  PU_col_name, 
                  spp_col_name
                  ) 
    {
    cat ("\n\nAbout to create PU_spp_pair_names...")
    
        #  First, create vectors of just then PU names and spp names alone.
        #  These are used later to build tables.
    
    PU_vertex_indices = 1:num_PUs
    PU_vertex_names = str_c ("p", PU_vertex_indices)
    
    spp_vertex_indices = 1:num_spp
    spp_vertex_names = str_c ("s", spp_vertex_indices)
    
        #  Now, create a near copy of the PU_spp_pair_indices table 
        #  but using the names of the PUs and species instead of their 
        #  indices.
    
    PU_spp_pair_names = 
        data.frame (PU_ID = str_c ("p", PU_spp_pair_indices [,PU_col_name]),
                    spp_ID = str_c ("s", PU_spp_pair_indices [,spp_col_name]), 
                    stringsAsFactors = FALSE)
    
    return (list (PU_spp_pair_names=PU_spp_pair_names, 
                  PU_vertex_names=PU_vertex_names, 
                  spp_vertex_names=spp_vertex_names))
    }

#===============================================================================

