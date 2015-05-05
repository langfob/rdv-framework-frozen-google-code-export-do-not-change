#===============================================================================

                #  source ("add_error_to_spp_occupancy_data.R")

#===============================================================================

#  History

#  BTL - 2015 04 30 - Created.

#===============================================================================

TESTING=FALSE

#===============================================================================

    #  Walk through the occupancy matrix (PU vs spp) and randomly 
    #  choose to flip some of the TPs to FNs and TNs to FPs based on the 
    #  given FP and FN error rates.
    #  Update the occupancy matrix (bpm) as you go along, but don't update 
    #  the PU_spp_pair_indices until you know all locations that have 
    #  flipped.  Update PU_spp_pair_indices at the end so that you don't 
    #  have to constantly resize this big array as you go along.

add_const_error_to_spp_occupancy_data = 
        function (bpm, FP_rates, FN_rates, num_PUs, num_spp, 
                  random_values  #  passing these in to make it easier to test
                                 #  in a reproducible way
                  ) 
    {
    cat ("\nStarting add_const_error_to_spp_occupancy_data loop.\n\n")
    
    for (cur_spp_row in 1:num_spp)
        {
        for (cur_PU_col in 1:num_PUs)
            {
#             cat ("\n[", cur_spp_row, ",", 
#                  cur_PU_col, 
#                  "]", sep='')
            if (bpm [cur_spp_row, cur_PU_col])
                {
                    #  TP:  This species DOES exist on this planning unit.
                    #       Randomly choose whether to replace a given TP  
                    #       with a false negative (FN)
                    #       i.e., simulate not detecting that spp on that PU.                    
                if (random_values [cur_spp_row, cur_PU_col] < FN_rates [cur_spp_row, cur_PU_col])
                    bpm [cur_spp_row, cur_PU_col] = 0
                
                }  else 
                {
                    #  TN:  This species does NOT exist on this planning unit.
                    #       Randomly choose whether to replace a given TN  
                    #       with a false positive (FP).                
                if (random_values [cur_spp_row, cur_PU_col] < FP_rates [cur_spp_row, cur_PU_col])
                    bpm [cur_spp_row, cur_PU_col] = 1
                
               }  #  end else - TN so set FP                
            }  #  end for - all PU cols
        }  #  end for - all spp rows

    return (bpm)
    }

#-------------------------------------------------------------------------------

test_add_const_error_to_spp_occupancy_data = function ()
    {
    num_PUs = 2
    num_spp = 3

    #--------------------
        
    bpm = matrix (c(0,1,1,0,1,0), nrow=num_spp, ncol=num_PUs, byrow=TRUE)
    cat ("\n\nIn test_add_const_error_to_spp_occupancy_data() before start of test.")
    cat ("\nbpm = \n")
    print (bpm)
    
    #--------------------
    
    set.seed (17)
    random_values = matrix (runif (num_PUs*num_spp), 
                            nrow=num_PUs, ncol=num_spp, byrow=TRUE)
    cat ("\nrandom_values = \n")
    print (random_values)
    
    #--------------------
    
    FP_rates = matrix (c(1,1,1,
                         0,0,0), nrow=num_spp, ncol=num_PUs, byrow=TRUE)
    FN_rates = matrix (c(0,0,0,
                         1,1,1), nrow=num_spp, ncol=num_PUs, byrow=TRUE)
    
    app_bpm = add_const_error_to_spp_occupancy_data (bpm, FP_rates, FN_rates, 
                                               num_PUs, num_spp, random_values) 

    cat ("\n\nApparent bpm = \n")
    print (app_bpm)

    cat ("\n\nShould look like = \n\t1    1    1\n\t0    0    0")

        #--------------------
    
    FP_rates = matrix (c(0,0,0,
                         1,1,1), nrow=num_spp, ncol=num_PUs, byrow=TRUE)
    FN_rates = matrix (c(1,1,1,
                         0,0,0), nrow=num_spp, ncol=num_PUs, byrow=TRUE)
    
    app_bpm = add_const_error_to_spp_occupancy_data (bpm, FP_rates, FN_rates, 
                                               num_PUs, num_spp, random_values) 

    cat ("\n\nApparent bpm after reversing FP and FN = \n")
    print (app_bpm)    

    cat ("\n\nShould look like = \n\t0    0    0\n\t1    1    1")
    }

if (TESTING) test_add_const_error_to_spp_occupancy_data ()

#===============================================================================

add_error_to_spp_occupancy_data = 
        function (parameters, bpm, num_PU_spp_pairs, num_PUs, num_spp) 
    {
    FP_const_rate = parameters$spp_occ_FP_const_rate
    FN_const_rate = parameters$spp_occ_FN_const_rate
    
    stratify_error_probabilities = FALSE
    if (! is.null (parameters$stratify_error_probabilities))
        stratify_error_probabilities = parameters$stratify_error_probabilities
        
    if (stratify_error_probabilities)
        {
            #  Usually, TNs will far outnumber TPs.
            #  Therefore, there will be far more opportunities to inject 
            #  FPs than FNs.  
            #  Consequently, even if the FP and FN rates are set to the  
            #  same value, there are likely to be far more FPs than FNs  
            #  in the apparent matrix.
            #  If you want to keep the opportunities for each of them 
            #  to be more balanced, then you can multiply the dominant 
            #  one by the lesser one's fraction of occurrence.
            #
            #  Example: if there are 
            #       - 100 entries total 
            #       - 70 TNs
            #       - 30 TPs 
            #  and you want 0.1 probability of FN, then you should get 
            #  approximately 3 FNs.  If you want the FPs to be balanced 
            #  by their opporunity but to have the same probability, 
            #  then x * 70 FPs must equal 3 FPs too.  
            #  So, the multiplier x = 3 / 70 = 3 / 0.7 ~ 0.0429
            #  i.e.,
            #  the adjusted_P(FP) = num_FNs / num_TNs
            
        num_TPs = sum (bpm)
        approx_num_FNs = round (FN_const_rate * num_TPs)
        
        num_TNs = length (bpm) - num_TPs
        FP_const_rate = approx_num_FNs / num_TNs
        
        cat ("\n\nComputing stratified version of FP_const_rate:", 
             "\n\tnum_TPs = ", num_TPs, 
             "\n\tapprox_num_FNs = ", approx_num_FNs, 
             "\n\tnum_TNs = ", num_TNs, 
             "\n\tFP_const_rate = ", FP_const_rate,
             "\n")             
        }
    
    FP_rates = matrix (rep (FP_const_rate, (num_PUs * num_spp)), 
                        nrow=num_spp,
                        ncol=num_PUs,
                        byrow=TRUE)
    
    FN_rates = matrix (rep (FN_const_rate, (num_PUs * num_spp)), 
                        nrow=num_spp,
                        ncol=num_PUs,
                        byrow=TRUE)
    
    random_values = matrix (runif (num_PUs * num_spp), 
                            nrow=num_spp,
                            ncol=num_PUs,
                            byrow=TRUE)
    
    app_spp_occupancy_data = 
        add_const_error_to_spp_occupancy_data (bpm, 
                                                FP_rates, FN_rates, 
                                                num_PUs, num_spp, 
                                                random_values)
    
    app_PU_spp_pair_indices = 
        build_PU_spp_pair_indices_from_occ_matrix (app_spp_occupancy_data, 
                                                    num_PUs, num_spp)
    
    return (list (app_PU_spp_pair_indices = app_PU_spp_pair_indices, 
                  app_spp_occupancy_data = app_spp_occupancy_data))
    }

#===============================================================================

