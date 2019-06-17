parseInput <- function(chart.lines,
                       keyset.select,
                       span = 0.1,
                       rate = 1.0,
                       lim.jck = NA,
                       lim.mtn = NA,
                       lim.dns = NA){
  
  require(osutools)
  require(magrittr)
  require(dplyr)
  
  source("r/createComparisonPlot.R")
  source("r/calculateDifficulty.R")
  source("r/createModels.R")
  
  start.time <- Sys.time()
  
  chart <- chartParse(chart.lines = chart.lines)
  chart %<>% mutate(offsets = offsets / rate)

  s.mdls <- createStaticModels(chart)
  plt <- createComparisonPlot(s.mdls, lim.jck, lim.mtn, lim.dns)
  dif <- calculateDifficulty(s.mdls)
  
  end.time <- Sys.time()
  dly = end.time - start.time
  return(list("plt" = plt,
              "dif" = dif,
              "dly" = dly))
}