require(ggplot2)
require(reshape2)
require(zoo)
require(dplyr)
require(magrittr)
require(microbenchmark)
{
  library(osutools)
}

microbenchmark(
  "al" = {
  # Chart Parser
    chart.path <- 'src/osu/princbride.osu'
    chart <- chart.parse(chart.path)
  
  # Replay Parser
    chart.rep <- replay.parse(chart, "src/feather/replay/3155787_tldne.feather",
                                ignore.threshold = 100)
  
  # Stress Simulation
    chart.sim <- stress.sim(chart = chart,
                              stress.init = 0)
  
  # Difference Broadcasting
    chart.bcst <- diff.broadcast(chart,
                                   ignore.types = c('lnotel'))
  
  # Alpha
    keyset.select <- '4'
    f.alpha <- function(diffs, moves.values){
      return(moves.values * (1/diffs ** 2))
    }
    chart.alpha <- alpha.calc(chart.bcst,
                              suppressMessages(f.create.move.mapping(keyset.select)),
                              f.alpha)
  }
, times = 1
)
