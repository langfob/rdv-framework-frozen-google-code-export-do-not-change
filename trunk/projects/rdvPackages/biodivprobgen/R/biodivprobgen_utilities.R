#===============================================================================

                        #  biodivprobgen_utilities.R

#===============================================================================

#  2015 04 27 - BTL
#       Created by extracting functions from generateSetCoverProblem.R.

#===============================================================================

    #  2015 04 08 - BTL
    #  I just got bitten very badly by the incredibly annoying behavior of R's 
    #  sample() function, so here is a replacement function that I need to 
    #  use everywhere now.
    #  When I called sample with a vector that sometimes had length n=1, 
    #  it sampled from 1:n instead of returning the single value.  
    #  This majorly screwed all kinds of things in a very subtle, very hard 
    #  to find way.

safe_sample = function (x,...) { if (length (x) == 1) x else sample (x,...) } 

#===============================================================================

    #  This function is used two different ways.
    #  It's called when the program quits because there are too many species 
    #  or it's called when the program runs successfully.  
    #  It's declared here because you don't know which path the program 
    #  will take.
    #  It should go in a file of misc utilities, but it might be the only 
    #  thing in that file at the moment.

write_results_to_files = function (results_df, parameters)
    {    
        #  Write the results out to 2 separate and nearly identical files.
        #  The only difference between the two files is that the run ID in 
        #  one of them is always set to 0 and in the other, it's the correct 
        #  current run ID.  This is done to make it easier to automatically 
        #  compare the output csv files of different runs when the only thing 
        #  that should be different between the two runs is the run ID.  
        #  Having different run IDs causes diff or any similar comparison to 
        #  think that the run outputs don't match.  If they both have 0 run ID, 
        #  then diff's output will correctly flag whether there are differences 
        #  in the outputs.
    
    results_df$run_ID [cur_result_row] = 0
    write.csv (results_df, file = parameters$summary_without_run_id_filename, row.names = FALSE)
    
    results_df$run_ID [cur_result_row] = parameters$run_id
    write.csv (results_df, file = parameters$summary_filename, row.names = FALSE)
    }

#===============================================================================

