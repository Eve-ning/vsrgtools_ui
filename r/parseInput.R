parseInput <- function(chart.lines = NA,
                       chart.path = NA,
                       keyset.select = '4',
                       span = 0.1,
                       rate = 1.0,
                       lim.hist = NA,
                       lim.line = NA,
                       dif.quant = 0.85,
                       dif.quant.type = 1,
                       make.plot = T,
                       plot.title = ""){
  
  require(osutools)
  require(magrittr)
  require(dplyr)
  
  source("r/createComparisonPlot.R")
  source("r/calculateDifficulty.R")
  source("r/createModels.R")
  
  start.time <- Sys.time()
  
  # chart.path = "local_tests/osu/4/Betwixt & Between - out of Blue (Shoegazer) [Abyss].osu"
  # 
  chart <- chartParse(chart.path = chart.path,
                      chart.lines = chart.lines)
  chart %<>% mutate(offsets = offsets / rate)

  s.mdls <- createStaticModels(chart, keyset.select)

  if (make.plot){
    plt <- createComparisonPlot(s.mdls, lim.hist, lim.line, span, plot.title)
  } else {
    plt <- ""
  }
  
  end.time <- Sys.time()
  dly = end.time - start.time
  return(list("plt" = plt,
              "s.mdls" = s.mdls,
              "dly" = dly))
}
