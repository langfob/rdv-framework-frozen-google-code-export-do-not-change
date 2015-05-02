#===============================================================================

                #  source ("add_error_to_spp_occupancy_data.R")

#===============================================================================

#  History

#  BTL - 2015 04 30 - Created.

#===============================================================================

#TESTING = FALSE

#===============================================================================

    #  Add a new PU/spp pair to the list of new False Positives to be added 
    #  to the PU_spp_pair_indices once all FPs have been identified.
    #  I'm making this a function because I will probably need to make it 
    #  more efficient but don't want to mess with it right now.

add_FP_at = function (a_PU_ID, a_spp_ID, new_FP_list)
    {
    if (is.null (new_FP_list))
        new_FP_list = list()
    
    new_FP_list [[length (new_FP_list) + 1]] = c(a_PU_ID, a_spp_ID)
        
    return (new_FP_list)
    }

#------------------------------------------

test_add_FP_at = function (new_FP_list = NULL)
    {
    for (cur_PU in 1:3)
        {
        for (cur_spp in 11:13)
            {
            new_FP_list = add_FP_at (cur_PU, cur_spp, new_FP_list)
            }
        }

    cat ("\n\nAt end of test_add_FP_at(), new_FP_list = \n")
    print (new_FP_list)
    cat ("\n")
    }

#------------------------------------------

if (TESTING) test_add_FP_at ()

#===============================================================================

possibly_replace_TN_with_FP = function (cur_FP_rate, 
                                          bpm, 
                                          cur_PU_row, cur_spp_col, 
                                          new_FPs_list = NULL
                                          )
    {                    
        #       Randomly choose whether to replace a given TN  
        #       with a false positive (FP).
    
    if (runif (1) < cur_FP_rate)
        {
        bpm [cur_PU_row, cur_spp_col] = 1
        
        new_FPs_list = add_FP_at (cur_PU_row, cur_spp_col, new_FPs_list)
        
        }  #  end if - set FP    
    
    return (list (bpm=bpm, new_FPs_list=new_FPs_list))
    }

#------------------------------------------

test_possibly_replace_TN_with_FP = function ()
    {
    bpm = matrix (c(0,1,1,0,1,0), nrow=2, ncol=3, byrow=2)
    new_FPs_list = NULL
    
        #  bpm should look like this:
        #            [,1] [,2] [,3]
        #       [1,]    0    1    1
        #       [2,]    0    1    0

    cat ("\n\nIn test_possibly_replace_TN_with_FP() before start of test.")
    cat ("\nbpm = \n")
    print (bpm)
    cat ("\nand new_FPs_list = \n")
    print (new_FPs_list)
    
    #--------------------
    
        #  This test should reset the value of element [2,1] from 0 to 1.
    
    cur_FP_rate = 1.0
    cur_PU_row = 2
    cur_spp_col = 1
    bpm_FPs_double = possibly_replace_TN_with_FP (cur_FP_rate, bpm, 
                                                  cur_PU_row, cur_spp_col, 
                                                  new_FPs_list)
    bpm          = bpm_FPs_double$bpm
    new_FPs_list = bpm_FPs_double$new_FPs_list
    
    
    cat ("\n\nAfter should have set element [", cur_PU_row, ", ", 
         cur_spp_col, "] to 1:", sep='')
    cat ("\nbpm = \n")
    print (bpm)
    cat ("\nand new_FPs_list = \n")
    print (new_FPs_list)
    assert_that (bpm [cur_PU_row, cur_spp_col] == 1)
    
     #--------------------
    
        #  This test should NOT reset the value of element [1,1] from 0 to 1.
    
    cur_FP_rate = 0.0
    cur_PU_row = 1
    cur_spp_col = 1
    bpm_FPs_double = possibly_replace_TN_with_FP (cur_FP_rate, bpm, 
                                                  cur_PU_row, cur_spp_col, 
                                                  new_FPs_list)
    bpm          = bpm_FPs_double$bpm
    new_FPs_list = bpm_FPs_double$new_FPs_list
    
    cat ("\n\nAfter should NOT have set element [", cur_PU_row, ", ", 
         cur_spp_col, "] to 1:", sep='')
    cat ("\nbpm = \n")
    print (bpm)
    cat ("\nand new_FPs_list = \n")
    print (new_FPs_list)
    assert_that (bpm [cur_PU_row, cur_spp_col] == 0)   
    }

#------------------------------------------

TESTING = TRUE
if (TESTING) test_possibly_replace_TN_with_FP ()
    
#===============================================================================
#===============================================================================

    #  Add a new PU/spp pair row number to the list of False Negatives whose  
    #  rows are to be deleted from the PU_spp_pair_indices once all FNs have 
    #  been identified.
    #  I'm making this a function because I will probably need to make it 
    #  more efficient but don't want to mess with it right now.

add_FN_at = function (PU_spp_pair_row_num, FN_vector)
    {
    if (is.null (FN_vector))
        FN_vector = vector (mode="integer", length=0)
        
    FN_vector [length (FN_vector) + 1] = PU_spp_pair_row_num
    
    return (FN_vector)
    }

#------------------------------------------

test_add_FN_at = function (FN_vector = NULL)
    {
    for (cur_row_num in 1:5)
        {
        FN_vector = add_FN_at (cur_row_num, FN_vector)
        }

    cat ("\n\nAt end of test_add_FN_vector (), FN_vector = \n")
    print (FN_vector)
    cat ("\n")
    }

#------------------------------------------

TESTING = TRUE
if (TESTING) test_add_FN_at ()

#===============================================================================

possibly_replace_TP_with_FN = function (cur_FN_rate, 
                                         bpm, 
                                         cur_PU_row, cur_spp_col, 
                                         PU_spp_pair_indices, 
                                         FN_vector = NULL
                                         )
    {
        #       Randomly choose whether to replace a given TP  
        #       with a false negative (FN)
        #       i.e., simulate not detecting that spp on that PU.    
    
    if (runif (1) < cur_FN_rate)
        {
        bpm [cur_PU_row, cur_spp_col] = 0
    
            #  Save the row number so that you can remove it 
            #  from the pairs list after you know all that 
            #  need to be removed.
            #  Could do it now, but it would cause the PU_spp_pair_indices 
            #  to be resized each time.  Seems likely to be more efficiently  
            #  done by R's vectorized operator that removes a set of indices 
            #  from an array (ie., the [-x] operator).
        
        PU_spp_pair_row = 
            which ((PU_spp_pair_indices$PU_ID == cur_PU_row) &
                   (PU_spp_pair_indices$spp_ID == cur_spp_col))
        
        FN_vector = add_FN_at (PU_spp_pair_row, FN_vector)

        }  #  end if - TP so set FN
    
    return (list (bpm=bpm, FN_vector=FN_vector))
    }

#===============================================================================
#===============================================================================

add_FPs_to_PU_spp_pair_indices = 
        function (new_FPs_list, 
                  PU_spp_pair_indices, 
                  PU_col_name, 
                  spp_col_name
                  ) 
    {
    num_FPs_to_add = length (new_FPs_list)
    if (num_FPs_to_add > 0)
        {
            #  Find end of current index list.  
            #  Need to do this now, before its size changes when you add 
            #  empty space for the new FPs in the next step.
        new_FP_start_index = (dim(PU_spp_pair_indices)[1]) + 1        

            #  Create space for the new FPs and tack it onto the end of 
            #  the current list of indices.
        empty_matrix_of_FPs_to_add = matrix (NA, nrow=num_FPs_to_add, ncol=2, 
                                             byrow=TRUE)  
        PU_spp_pair_indices = rbind (PU_spp_pair_indices, 
                                     empty_matrix_of_FPs_to_add)
        
            #  Copy the new FPs into the added space.
        for (cur_PU_spp_row in seq (new_FP_start_index, 
                                    length (PU_spp_pair_indices)))
            {
            cur_PU_spp_pair = new_FPs_list [[cur_PU_spp_row]]
            
            PU_spp_pair_indices [cur_PU_spp_row, PU_col_name] = cur_PU_spp_pair [1]            
            PU_spp_pair_indices [cur_PU_spp_row, spp_col_name] = cur_PU_spp_pair [2]
            
            }  #  end for - added rows
        }  #  end if  there are FPs to add
    
    return (PU_spp_pair_indices)
    }

#===============================================================================

possibly_replace_TP_or_TN = function (bpm, 
                                      cur_PU_row, cur_spp_col, 
                                      FN_rates, FP_rates, 
                                      new_FPs_list = NULL, 
                                      FN_vector = NULL) 
    {
    if (bpm [cur_PU_row, cur_spp_col])
        {
            #  TP:  This species DOES exist on this planning unit.
        
        cur_FN_rate = FN_rates [cur_PU_row, cur_spp_col]
        bpm_FNs_double = possibly_replace_TP_with_FN (cur_FN_rate, bpm, 
                                                      cur_PU_row, cur_spp_col, 
                                                      PU_spp_pair_indices, 
                                                      FN_vector)
                        
        bpm = bpm_FNs_double$bpm
        FN_vector = bpm_FNs_double$FN_vector
        
        }  else
        {
           #  TN:  This species does NOT exist on this planning unit.
        
        cur_FP_rate    = FP_rates [cur_PU_row, cur_spp_col]
        bpm_FPs_double = possibly_replace_TN_with_FP (cur_FP_rate, bpm, 
                                                      cur_PU_row, cur_spp_col, 
                                                      new_FPs_list)
        
        bpm          = bpm_FPs_double$bpm
        new_FPs_list = bpm_FPs_double$new_FPs_list
        
        }  #  end else - TN so set FP
    
    return (list (bpm, new_FPs_list, FN_vector))
    }

#===============================================================================
#===============================================================================

add_error_to_spp_occupancy_data = 
    function (PU_spp_pair_indices,  #  
              bpm,  #  0-1 integer matrix with dim num_PU rows by num_spp cols
              errors_to_add,  #  2 element list: FP_rates matrix and FN_rates matrix
                              #  where the matrices are floating points in 0-1
                              #  and dim num_PU rows by num_spp cols
              num_PUs,  #  
              num_spp,  #  
              PU_col_name,  #  
              spp_col_name  #
              ) 
    {
    FP_rates = errors_to_add$FP_rates,
    FN_rates = errors_to_add$FN_rates)    
    new_FPs_list = NULL

        #  Walk through the occupancy matrix (PU vs spp) and randomly 
        #  choose to flip some of the TPs to FNs and TNs to FPs based on the 
        #  given FP and FN error rates.
        #  Update the occupancy matrix (bpm) as you go along, but don't update 
        #  the PU_spp_pair_indices until you know all locations that have 
        #  flipped.  Update PU_spp_pair_indices at the end so that you don't 
        #  have to constantly resize this big array as you go along.

    for (cur_PU_row in 1:num_PUs)
        {
        for (cur_spp_col in 1:num_spp)
            {
                #  Flip the occupancy of this spp on this PU 
                #  if it's called for.
            replacement_triple = 
                possibly_replace_TP_or_TN (bpm, 
                                           cur_PU_row, cur_spp_col, 
                                           FN_rates, FP_rates, 
                                           new_FPs_list, FN_vector)
            
                #  Extract the data structures that may have changed.
            bpm          = replacement_triple$bpm
            new_FPs_list = replacement_triple$new_FPs_list
            FN_vector    = replacement_triple$FN_vector
                
            }  #  end for - all spp cols
        }  #  end for - all PU rows

        #  Remove the FNs from PU_spp_pair_indices.
    PU_spp_pair_indices = PU_spp_pair_indices [- FN_vector]

        #  Add the FPs to PU_spp_pair_indices.
    add_FPs_to_PU_spp_pair_indices (new_FPs_list, PU_spp_pair_indices, 
                                    PU_col_name, spp_col_name)   
        
    #--------------------
    
    return (list (app_PU_spp_pair_indices = PU_spp_pair_indices,
                  app_bpm = bpm))
    }

#-------------------------------------------------------------------------------

test_add_error_to_spp_occupancy_data ()
    {
    PU_spp_pair_indices = NULL
    bpm = NULL
    errors_to_add = NULL
    num_PUs = 0
    num_spp = 0

    add_error_to_spp_occupancy_data (PU_spp_pair_indices,  
                                     bpm, 
                                     errors_to_add, 
                                     num_PUs, 
                                     num_spp,
                                     PU_col_name,  
                                     spp_col_name
                                     )     
    }

TESTING = FALSE
if (TESTING) test_add_error_to_spp_occupancy_data ()

#===============================================================================

