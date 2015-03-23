#===============================================================================

                        #  aggregate_df_list.R

#  Code to collapse a bunch of biodivprobgen csv files into a single file 
#  with all failed runs removed.

#===============================================================================

#  History:

#  2014 ?? ?? - BTL
#       Created initial one-off script with very little encapsulated in 
#       functions.
#
#  2015 01 10 - BTL
#       Refactoring into functions and more generalizable behavior.  

#===============================================================================

    #  This web page on dplyr may be useful to all this...
#  http://rpubs.com/justmarkham/dplyr-tutorial

#===============================================================================

remove_failed_runs_from_full_run_list = function (full_run_list, failed_run_list) 
    {
    if (! is.null (failed_run_list))
        full_run_list = full_run_list [-failed_run_list]
    
    return (full_run_list)
    }

#===============================================================================

build_cur_file_name = 
    function (run_num, 
              top_dir_name_without_slash, #  "/Users/bill/tzar/outputdata/biodivprobgen/test500unifRand_p_r_n_a", 
              run_num_dir_name_tail_without_slash = "_default_scenario", 
              file_name = "prob_diff_results.csv"
              )
    {
    full_cur_file_path = paste0 (top_dir_name_without_slash, "/", 
                                 run_num, 
                                 run_num_dir_name_tail_without_slash, "/", 
                                 file_name)
    
    return (full_cur_file_path)
    }

#===============================================================================

read_successful_results_into_aggregated_data_frame = 
    function (successful_run_list, 
              top_dir_name_without_slash, #  "/Users/bill/tzar/outputdata/biodivprobgen/test500unifRand_p_r_n_a", 
              run_num_dir_name_tail_without_slash = "_default_scenario", 
              file_name = "prob_diff_results.csv"
             )         
    {
        #  Load current file into a data frame as the seed for  
        #  the fully aggregated file.  
        #  All of the other results files in the list will be 
        #  read in and appended to this seed data frame.
#browser()    
    full_cur_file_path = build_cur_file_name (successful_run_list [1], 
                                              top_dir_name_without_slash, 
                                              run_num_dir_name_tail_without_slash, 
                                              file_name)
    aggregated_df = read.csv (full_cur_file_path, header=TRUE)
    
    for (cur_run_num in successful_run_list [-1])
        {
        full_cur_file_path = 
            build_cur_file_name (cur_run_num, 
                                 top_dir_name_without_slash, 
                                 run_num_dir_name_tail_without_slash, 
                                 file_name
                                 )

        cur_run_df = read.csv (full_cur_file_path, header=TRUE)
        
        cat ("----->  cur_run_num = '", cur_run_num, "'\n")
        
            #  Append current file line to aggregate file.
        aggregated_df = rbind (aggregated_df, cur_run_df)
        }
    
    return (aggregated_df)
    }

#===============================================================================

write_aggregated_results_file <- 
    function (full_run_list, 
              aggregated_df, 
              runset_name, 
              top_dir_name_without_slash = "/Users/bill/tzar/outputdata/biodivprobgen/default_runset", 
              aggregated_file_name = "aggregated_prob_diff_results"
              ) 
    {
    run_range_start = full_run_list [1]
    run_range_end = full_run_list [length (full_run_list)]    
    run_range_string = paste0 ("runs_", run_range_start, "-", run_range_end)
    
    full_aggregated_filename = paste0 (top_dir_name_without_slash, 
                                       "/",
                                       aggregated_file_name, 
                                       "__", 
                                       runset_name, 
                                       ".", 
                                        run_range_string, 
                                        ".csv")
    write.csv (aggregated_df, 
               file = full_aggregated_filename, 
               row.names = FALSE)
    }

#===============================================================================

do_it = function (full_run_list, failed_run_list, top_dir_name_without_slash, 
                  runset_name, there_are_failed_runs=TRUE)
    {
    cur_successful_run_list = full_run_list
    if (there_are_failed_runs)
        {
        cur_successful_run_list = 
            remove_failed_runs_from_full_run_list (full_run_list, failed_run_list)
        }
        
    
    aggregated_df = 
        read_successful_results_into_aggregated_data_frame (cur_successful_run_list, 
                                                            top_dir_name_without_slash
                                                            )
    
    write_aggregated_results_file (cur_successful_run_list, 
                                   aggregated_df, 
                                   runset_name, 
                                   top_dir_name_without_slash
                                   )
    }

#===============================================================================

    #  Data old runs.

#       OLD...
# full_run_list = 1:327
# failed_run_list = c (4,6,7,9,12,14,33,34,37,41,45,46,47,
#                     54,65,66,69,71,72,73,77,80,81,84,92,98,
#                     104,115,116,120,124,126,128,129,133,143,147,
#                     151,154,159,163,172,183,184,189,196,197,
#                     201,202,203,205,206,207,214,215,219,220,226,234,245,249,
#                     258,267,268,277,279,282,288,290,291,292,298,
#                     303,304,307,312,313,314,321)

#===============================================================================

# full_run_list__test100unifRand_p_r_n_a_seed_301_with_error_trapping_and_timing = 1:100
# failed_run_list__test100unifRand_p_r_n_a_seed_301_with_error_trapping_and_timing = 
#     c (2, 3, 5, 9, 10, 11, 12, 13, 15, 19, 21, 23, 26, 28, 30, 
#        31, 33, 36, 37, 41, 42, 44, 46, 48, 51, 52, 54, 55, 56, 
#        57, 59, 60, 62, 63, 64, 65, 69, 70, 73, 74, 75, 76, 77, 
#        78, 83, 86, 87, 95, 96, 98, 99) 
# top_dir_name_without_slash_301 = "/Users/bill/tzar/outputdata/biodivprobgen/test100unifRand_p_r_n_a_seed_301_with_error_trapping_and_timing__GOOD_SAVE"
# 
# 
# do_it (full_run_list__test100unifRand_p_r_n_a_seed_301_with_error_trapping_and_timing, 
#        failed_run_list__test100unifRand_p_r_n_a_seed_301_with_error_trapping_and_timing, 
#        top_dir_name_without_slash_301)
# 
#===============================================================================

# full_run_list__test100unifRand_p_r_n_a_seed_401_with_error_trapping_and_timing = 1:100
# failed_run_list__test100unifRand_p_r_n_a_seed_401_with_error_trapping_and_timing = 
#     c (1, 2, 4, 7, 8, 12, 14, 20, 22, 25, 29, 31, 32, 37, 39, 40, 
#        41, 43, 45, 46, 47, 50, 52, 53, 55, 59, 62, 64, 65, 71, 72, 
#        77, 82, 83, 84, 86, 88, 91, 94, 95, 96, 98, 100)
# top_dir_name_without_slash_401 = "/Users/bill/tzar/outputdata/biodivprobgen/test100unifRand_p_r_n_a_seed_401_with_error_trapping_and_timing__GOOD_SAVE"
# 
#  
# do_it (full_run_list__test100unifRand_p_r_n_a_seed_401_with_error_trapping_and_timing, 
#        failed_run_list__test100unifRand_p_r_n_a_seed_401_with_error_trapping_and_timing, 
#        top_dir_name_without_slash_401)
# 
#===============================================================================

# full_run_list__test100unifRand_p_r_n_a_seed_501_with_error_trapping_and_timing = 1:100
# failed_run_list__test100unifRand_p_r_n_a_seed_501_with_error_trapping_and_timing = 
#     c (2, 4, 6, 8, 13, 19, 22, 23, 24, 25, 28, 29, 33, 37, 39, 40, 
#        41, 42, 43, 45, 49, 50, 53, 54, 55, 59, 67, 68, 71, 72, 75, 
#        76, 78, 79, 81, 88, 89, 91, 92, 93, 98, 99)
# top_dir_name_without_slash_501 = "/Users/bill/tzar/outputdata/biodivprobgen/test100unifRand_p_r_n_a_seed_501_with_error_trapping_and_timing__GOOD_SAVE"
# 
# 
# do_it (full_run_list__test100unifRand_p_r_n_a_seed_501_with_error_trapping_and_timing, 
#        failed_run_list__test100unifRand_p_r_n_a_seed_501_with_error_trapping_and_timing, 
#        top_dir_name_without_slash_501)
# 
#===============================================================================

# full_run_list__test100unifRand_p_r_n_a_seed_601_with_error_trapping_and_timing = 1:100
# failed_run_list__test100unifRand_p_r_n_a_seed_601_with_error_trapping_and_timing = 
#     c (3, 4, 6, 7, 8, 10, 11, 13, 16, 17, 19, 26, 27, 28, 30, 31, 
#        33, 34, 41, 42, 43, 44, 46, 47, 48, 49, 52, 57, 59, 61, 65, 
#        68, 79, 87, 90, 93, 94, 95, 97, 98, 99)
# top_dir_name_without_slash_601 = "/Users/bill/tzar/outputdata/biodivprobgen/test100unifRand_p_r_n_a_seed_601_with_error_trapping_and_timing__GOOD_SAVE"
# 
# 
# do_it (full_run_list__test100unifRand_p_r_n_a_seed_601_with_error_trapping_and_timing, 
#        failed_run_list__test100unifRand_p_r_n_a_seed_601_with_error_trapping_and_timing, 
#        top_dir_name_without_slash_601)
# 
#===============================================================================

# full_run_list__test100unifRand_p_r_n30_retry = 1:100
# failed_run_list__test100unifRand_p_r_n30_retry = c ()
# top_dir_name_without_slash_n30_retry = "/Users/bill/tzar/outputdata/biodivprobgen/test100unifRand_p_r_n30_retry__GOOD_SAVE"
# 
# 
# do_it (full_run_list__test100unifRand_p_r_n30_retry, 
#        failed_run_list__test100unifRand_p_r_n30_retry, 
#        top_dir_name_without_slash_n30_retry)

#===============================================================================

# runset_name = test100unifRand_p_r_n_a_seed_701_in_phase_transition_area
# full_run_list__test100unifRand_p_r_n_a_seed_701_in_phase_transition_area = 1:100
# failed_run_list__test100unifRand_p_r_n_a_seed_701_in_phase_transition_area = 
#     c(3, 4, 6, 7, 8, 9, 10, 13, 16, 17, 19, 26, 27, 28, 30, 
#       33, 34, 41, 42, 43, 46, 47, 48, 49, 57, 59, 61, 65, 
#       68, 79, 87, 90, 93, 94, 95, 97, 98, 99) 
# top_dir_name_without_slash_701_in_phase = "/Users/bill/tzar/outputdata/biodivprobgen/test100unifRand_p_r_n_a_seed_701_in_phase_transition_area__GOOD_SAVE"
# 
# 
# do_it (full_run_list__test100unifRand_p_r_n_a_seed_701_in_phase_transition_area, 
#        failed_run_list__test100unifRand_p_r_n_a_seed_701_in_phase_transition_area, 
#        top_dir_name_without_slash_701_in_phase, 
#        runset_name)

#===============================================================================

runset_name = "bdpg_400runs"

full_run_list__bdpg_400runs = 
    c (
#         13742, 13856, 13857, 13858, 13859, 13860, 13861, 13863, 13864, 13867, 
#         13868, 13869, 13870, 13871, 13969, 13970, 13971, 13973, 13974, 14068, 
#         14069, 14070, 14071, 14073, 14074, 14077, 14078, 14079, 14083, 14086, 
#         14091, 14094, 14097, 14099, 14100, 14101, 14102, 14104, 14105, 14107, 
#         14112, 14116, 
            
            #  Number of columns in data frame changes here, so these must be 
            #  the good, last runs.
        
        14169, 14172, 14173, 14178, 14179, 14180, 14182, 14183, 
        14186, 14196, 14200, 14203, 14206, 14207, 14210, 14212, 14215, 14216, 
        14218, 14219, 14223, 14227, 14228, 14229, 14232, 14235, 14239, 14243, 
        14244, 14245, 14248, 14249, 14252, 14253, 14255, 14258, 14260, 14261, 
        14266, 14267, 14269, 14277, 14280, 14282, 14289, 14296, 14298, 14301, 
        14302, 14305, 14307, 14308, 14309, 14310, 14311, 14314, 14315, 14317, 
        14318, 14322, 14323, 14324, 14326, 14327, 14330, 14332, 14334, 14338, 
        14342, 14343, 14345, 14348, 14349, 14350, 14352, 14353, 14355, 14357, 
        14361, 14363, 14364, 14365, 14366, 14368, 14372, 14373, 14374, 14377, 
        14379, 14386, 14389, 14392, 14394, 14396, 14402, 14404, 14406, 14409, 
        14412, 14413, 14414, 14416, 14420, 14421, 14427, 14432, 14436, 14437, 
        14440, 14444, 14449, 14450, 14454, 14458, 14460, 14461, 14462, 14464, 
        14465, 14466, 14467, 14470, 14474, 14475, 14476, 14478, 14479, 14483, 
        14484, 14485, 14486, 14487, 14488, 14492, 14493, 14495, 14500, 14501, 
        14502, 14503, 14505, 14508, 14512, 14513, 14514, 14515, 14516, 14517, 
        14518, 14519, 14521, 14523, 14525, 14528, 14529, 14531, 14533, 14535, 
        14536, 14539, 14542, 14543, 14544, 14545, 14546, 14549, 14550, 14556, 
        14561, 14562, 14566, 14567
        )

failed_run_list__bdpg_400runs = c() 
top_dir_name_without_slash = "/Users/bill/D/rdv-framework/projects/rdvPackages/biodivprobgen/R/Aggregated_results/bdpg_400runs"


do_it (full_run_list__bdpg_400runs, 
       failed_run_list__bdpg_400runs, 
       top_dir_name_without_slash, 
       runset_name, 
       there_are_failed_runs=FALSE)

#===============================================================================



