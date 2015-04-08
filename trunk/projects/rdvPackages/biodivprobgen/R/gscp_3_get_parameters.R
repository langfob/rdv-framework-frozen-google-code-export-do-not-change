#===============================================================================

                        #  gscp_3_get_parameters.R

#===============================================================================

    #  Dummy function to build parameters list if tzar was not run.
    #  This is just meant as a place holder that other users could modify 
    #  if they were neither running tzar nor running the tzar emulator.
    #  They would just change all of the NA values in here to whatever 
    #  they want for the run.  
    #  More lines may need to be added to this in the future if more 
    #  values from the parameters list are used in this program.  
    #  I generated this list by running the following bash command and 
    #  editing the resulting lines:
    #       grep 'parameters\$' generateSetCoverProblem.R

    #  2015 04 08 - BTL
    #  Note that the variables listed in this routine are very likely to be 
    #  out of date due to the constant evolution of the rest of the code 
    #  for this project.  
    #  If you're going to use this local_build_parameters_list() function, 
    #  you should rebuild it to match the variables currently used in the 
    #  rest of the code.  The code shown here for this function is only here 
    #  to provide an example of what it might look like based on the parameters 
    #  that were in use when it was first generated.  

local_build_parameters_list = function ()
    {   
    parameters = list()
    
    parameters$seed = NA
    parameters$integerize_string = NA
    parameters$n__num_groups = NA
    parameters$use_unif_rand_n__num_groups = NA
    parameters$n__num_groups_lower_bound = NA
    parameters$n__num_groups_upper_bound = NA
    parameters$alpha__ = NA
    parameters$use_unif_rand_alpha__ = NA
    parameters$alpha___lower_bound = NA
    parameters$alpha___upper_bound = NA
    parameters$p__prop_of_links_between_groups = NA
    parameters$use_unif_rand_p__prop_of_links_between_groups = NA
    parameters$p__prop_of_links_between_groups_lower_bound = NA
    parameters$p__prop_of_links_between_groups_upper_bound = NA
    parameters$r__density = NA
    parameters$use_unif_rand_r__density = NA
    
        #  BTL - 2015 03 19
        #  Not sure why these bounds on r__density said p__r__... instead 
        #  of just r__...
        #  So, replacing the p__r__... in gscp_3..., gscp_5..., and in 
        #  project.yaml.

#    parameters$p__r__density_lower_bound = NA
    parameters$r__density_lower_bound = NA
#    parameters$p__r__density_upper_bound = NA
    parameters$r__density_upper_bound = NA
    
    parameters$base_for_target_num_links_between_2_groups_per_round = NA
    parameters$at_least_1_for_target_num_links_between_2_groups_per_round = NA
    parameters$marxan_spf_const = NA
    parameters$marxan_num_reps = NA
    parameters$marxan_num_iterations = NA
    parameters$run_id = NA
    parameters$summary_filename = NA

    return (parameters)
    }

#-------------------------------------------------------------------------------

if (! running_tzar_or_tzar_emulator)
    {
    if (exists ("parameters"))
        {
        system.quit (paste0 ("\n\nSomething is wrong.  ", 
                             "Not running tzar or tzar emulator but ", 
                             "parameters variable still exists.\n\n"))
        
        } else  parameters = local_build_parameters_list ()
    }

#===============================================================================

