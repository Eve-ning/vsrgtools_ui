f.create.move.mapping <- function(keyset.select=NA,
                                  keyset=NA,
                                  mapping=NA){
  #' Creates the mapping to be used alongside with
  #' the broadcasted chart.
  #' 
  #' @description
  #' Using the broadcasted format, this function maps
  #' the values provided by `mapping`
  #' 
  #' This can also be skipped if you're doing a custom
  #' mapping
  #' 
  #' @param keyset.select A **character vector** based on 
  #' type of keyset.
  #' 
  #' Valid Keyset.select values are '4','5', ..., '8SP','8SY','9'
  #' Only 8K has special keysets
  #' 8SYM: 8 Key Symmetry
  #' 8SPL: 8 Key Special (Left)
  #' 8SPR: 8 Key Special (Right)
  #' 
  #' @param keyset A **data.frame** based on type of keyset.
  #' 
  #' Fingers are denoted as
  #' P|inky
  #' R|ing
  #' M|iddle
  #' I|ndex
  #' T|humb
  #' 
  #' Column keys and fingers is required.
  #' 
  #' An example of keyset would be 
  #' '7' = data.frame(keys = 1:7,
  #'                  fingers = c('R','M','I','T','I','M','R'))
  #' 
  #' @param mapping A custom **5 by 5 matrix** to be used
  #' to map onto the finger. If NA, a default would be used
  #' 
  #' An example of a mapping. Values can change, but not
  #' the format.
  #' 
  #' pr means pinky to ring, rm means ring to middle, ...
  #' 
  #' # [P] [R] [M] [I] [T]
  #' c(7.0,5.0,3.0,2.7,2.7), # [P] pp,pr,pm,pi,pt
  #' c(6.0,6.0,2.5,2.0,2.0), # [R] rp,rr,rm,ri,rt
  #' c(3.5,3.0,5.0,1.0,1.3), # [M] mp,mr,mm,mi,mt
  #' c(2.7,1.2,1.2,5.0,2.4), # [I] ip,ir,im,ii,it
  #' c(2.7,1.7,1.5,1.9,5.0)  # [T] tp,tr,tm,ti,tt

  # Loads Mapping, if NA, it's defaulted
  f.load.mapping <- function(mapping){
    #' Loads the fngr mapping
    #' 
    #' @description 
    #' If there is no specified mapping, a default
    #' will be loaded
    #' 
    #' Details of the format is located in the
    #' parent help
    
    fngr <- data.frame(P = c(rep(0,5)),
                       R = c(rep(0,5)),
                       M = c(rep(0,5)),
                       I = c(rep(0,5)),
                       T = c(rep(0,5)))
    
    # If not defined, we will load default
    if (is.na(mapping)){
      fngr[] = c(
        # [P] [R] [M] [I] [T]
        c(7.0,5.0,3.0,2.7,2.7), # [P] pp,pr,pm,pi,pt
        c(6.0,6.0,2.5,2.0,2.0), # [R] rp,rr,rm,ri,rt
        c(3.5,3.0,5.0,1.0,1.3), # [M] mp,mr,mm,mi,mt
        c(2.7,1.2,1.2,5.0,2.4), # [I] ip,ir,im,ii,it
        c(2.7,1.7,1.5,1.9,5.0)  # [T] tp,tr,tm,ti,tt
      )
    } else {
      fngr[] = mapping
    }
    
    fngr$froms = c('P','R','M','I','T')
    
    fngr %<>% 
      melt(variable.name = 'tos',
           value.name = 'moves')
    return(fngr)
  }
  
  # Chooses between keyset or keyset.select, if both
  # NA, stop()
  f.load.keyset <- function(keyset, keyset.select){
    if (!is.na(keyset)){
      return(keyset)
    } else if (!is.na(keyset.select)){
    move.keysets = list(
      '4' = data.frame(keys = 1:4,
                       fingers = c('M','I','I','M')),
      '5' = data.frame(keys = 1:5,
                       fingers = c('M','I','T','I','M')),
      '6' = data.frame(keys = 1:6,
                       fingers = c('R','M','I','I','M','R')),
      '7' = data.frame(keys = 1:7,
                       fingers = c('R','M','I','T','I','M','R')),
      '8SPL' = data.frame(keys = 1:8,
                          fingers = c('P','R','M','I','T','I','M','R')),
      '8SPR' = data.frame(keys = 1:8,
                          fingers = c('R','M','I','T','I','M','R','P')),
      '8SYM' = data.frame(keys = 1:8,
                          fingers = c('R','M','I','T','T','I','M','R')),
      '9' = data.frame(keys = 1:9,
                       fingers = c('P','R','M','I','T','I','M','R','P'))
    )
    return(move.keysets[[keyset.select]])
    } else {
    stop("Either keyset or keyset.select must be defined.")
    }
  }
  
  move.mapping <- f.load.mapping(mapping)
  move.keyset <- f.load.keyset(keyset, keyset.select)

  # Merges both data.frames together
  f.merge <- function(mapping, keyset) {
    mapping %<>% 
      merge(keyset,
            by.x = 'froms',
            by.y = 'fingers')
    colnames(mapping)[ncol(mapping)] <- "keys.froms"
    mapping %<>% 
      merge(keyset,
            by.x = 'tos',
            by.y = 'fingers')
    colnames(mapping)[ncol(mapping)] <- "keys.tos"
    
    mapping <- mapping[3:5] # Return only the required columns.
    return(mapping)
  }
  
  move.mapping %<>%
    f.merge(move.keyset) 
  
  return(move.mapping)
}

