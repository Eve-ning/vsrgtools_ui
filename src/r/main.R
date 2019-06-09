require(ggplot2)
require(reshape2)
require(zoo)
require(dplyr)
require(magrittr)
require(microbenchmark)
{
source("src/r/chart_parser.R")
source("src/r/stress_sim.R")
source("src/r/replay_parser.R")
source("src/r/diff_broadcast.R")
source("src/r/create_move_mapping.R")
source("src/r/alpha_calc.R")
}
microbenchmark(
  "al" = {
  # Chart Parser
    chart.path <- 'src/osu/princbride.osu'
    chart <- f.chart.parse(chart.path)
  
  # Replay Parser
    chart.rep <- f.replay.parse(chart, "src/feather/replay/3155787_tldne.feather",
                                ignore.threshold = 100)
  
  # Stress Simulation
    chart.sim <- f.stress.sim(chart = chart,
                              stress.init = 0)
  
  # Difference Broadcasting
    chart.bcst <- f.diff.broadcast(chart,
                                   ignore.types = c('lnotel'))
  
  # Alpha
    keyset.select <- '4'
    f.alpha <- function(diffs, moves.values){
      return(moves.values * (1/diffs ** 2))
    }
    chart.alpha <- f.alpha.calc(chart.bcst,
                                suppressMessages(f.create.move.mapping(keyset.select)),
                                f.alpha)
  }
, times = 5
)
