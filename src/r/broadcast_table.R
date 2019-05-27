#' ! This is a user-defined file !
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

keys = 7
move.fngr <- data.frame(P = c(rep(0,5)),
                        R = c(rep(0,5)),
                        M = c(rep(0,5)),
                        I = c(rep(0,5)),
                        T = c(rep(0,5)))

# pp,pr,pm,pi,pt
# rp,rr,rm,ri,rt
# mp,mr,mm,mi,mt
# ip,ir,im,ii,it
# tp,tr,tm,ti,tt

move.fngr[] = c(
  # [P] [R] [M] [I] [T]
  c(7.0,5.0,3.0,2.7,2.7), # [P]
  c(6.0,6.0,2.5,2.0,2.0), # [R]
  c(3.5,3.0,5.0,1.0,1.3), # [M]
  c(2.7,1.2,1.2,5.0,2.4), # [I]
  c(2.7,1.7,1.5,1.9,5.0)  # [T]
)
bcst.match

