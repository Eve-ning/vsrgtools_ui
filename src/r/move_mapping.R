#' ! This is a user-defined file 
#'We will probably port this towards a RShiny UI
#'
#'Broadcast Table
#'The broadcast table aims to do an INNER JOIN with
#'the current broadcasted data.frame.
#'
#'It will be joined on 'keys' and 'diff.types'
#'keys : <x>
#'diff.types: X<x>.diff

#'Instead of defining every combination, we will only look
#'at the fingering, all left hand movements are reflected
#'onto the right hand for fairness.
#'
#'Hence, 1 -> 2 = 7 -> 6 for 7K
#'
#'With this, we just need to define 25 combinations, less 
#'if some combinations aren't used.
#'
#'Fingers are denoted as
#'P|inky
#'R|ing
#'M|iddle
#'I|ndex
#'T|humb
#'
#'So the parameter denoting Pinky to Ring would be move.p.r
#'
#'Function evaluated would be:
#'move.f <- function(diff, move) {
#'    ...
#'    return(val)
#'}


move.fngr <- data.frame(P = c(rep(0,5)),
                        R = c(rep(0,5)),
                        M = c(rep(0,5)),
                        I = c(rep(0,5)),
                        T = c(rep(0,5)))

move.fngr[] = c(
  # [P] [R] [M] [I] [T]
  c(7.0,5.0,3.0,2.7,2.7), # [P] pp,pr,pm,pi,pt
  c(6.0,6.0,2.5,2.0,2.0), # [R] rp,rr,rm,ri,rt
  c(3.5,3.0,5.0,1.0,1.3), # [M] mp,mr,mm,mi,mt
  c(2.7,1.2,1.2,5.0,2.4), # [I] ip,ir,im,ii,it
  c(2.7,1.7,1.5,1.9,5.0)  # [T] tp,tr,tm,ti,tt
)
move.fngr$froms = c('P','R','M','I','T')
move.fngr %<>% 
  melt(variable.name = 'tos',
       value.name = 'moves')

move.mapping = list(
  move.key.4 = data.frame(keys = 1:4,
                          fingers = c('M','I','I','M')),
  move.key.5 = data.frame(keys = 1:5,
                          fingers = c('M','I','T','I','M')),
  move.key.6 = data.frame(keys = 1:6,
                          fingers = c('R','M','I','I','M','R')),
  move.key.7 = data.frame(keys = 1:7,
                          fingers = c('R','M','I','T','I','M','R')),
  move.key.8SP = data.frame(keys = 1:8,
                            fingers = c('P','R','M','I','T','I','M','R')),
  move.key.8SY = data.frame(keys = 1:8,
                            fingers = c('R','M','I','T','T','I','M','R')),
  move.key.9 = data.frame(keys = 1:9,
                          fingers = c('P','R','M','I','T','I','M','R','P'))
)

f.fngr.merge <- function(fngr, mapping) {
  fngr %<>% 
    merge(mapping,
          by.x = 'froms',
          by.y = 'fingers')
  colnames(fngr)[ncol(fngr)] <- "keys.froms"
  fngr %<>% 
    merge(mapping,
          by.x = 'tos',
          by.y = 'fingers')
  colnames(fngr)[ncol(fngr)] <- "keys.tos"
  
  fngr <- fngr[3:5] # Return only the required columns.
  return(fngr)
}

move.fngr %<>%
  f.fngr.merge(move.mapping$move.key.4)

