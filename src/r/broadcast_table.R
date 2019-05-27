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
bcst.match <- data.frame(matrix(nrow = keys, ncol = keys))



bcst.match[] = c(
  
  c(1,2,3,4,5,6,7),
  c(1,2,3,4,5,6,7),
  c(1,2,3,4,5,6,7),
  c(1,2,3,4,5,6,7),
  c(1,2,3,4,5,6,7),
  c(1,2,3,4,5,6,7),
  c(1,2,3,4,5,6,7)
  
)
bcst.match

