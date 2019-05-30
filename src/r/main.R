library(ggplot2)
library(feather)
library(reshape2)
library(zoo)
library(dplyr)
library(magrittr)

source("src/r/chart_parser.R")
source("src/r/stress_sim.R")
source("src/r/replay_parser.R")
source("src/r/diff_broadcast.R")
source("src/r/move_mapping.R")
source("src/r/alpha_calc.R")

# chart.rep <- f.replay.parse(chart, "src/feather/replay/3155787_tldne.feather")
  
# Chart Parser
{
chart.path <- 'src/osu/aiae.osu'
chart <- f.chart.parse(chart.path)
}

# Stress Simulation
{
  f.stress.decay <- function(stress, duration){
    return(stress / 1.5 ** (duration / 10000))
  }
  f.stress.spike <- function(stress, args){
    return((stress + args$adds) / args$mults)
  }
  stress.mapping <-
    data.frame(types = c("note", "lnoteh", "lnotel"),
               adds  = c(50, 50, 20),
               mults = c(1,1,1))
  chart.sim <- f.stress.sim(chart = chart,
                            f.spike = f.stress.spike,
                            f.decay = f.stress.decay,
                            df.mapping = stress.mapping,
                            stress.init = 0)
}

# Difference Broadcasting
chart.bcst <- f.diff.broadcast(chart,
                               ignore.types = c('lnotel'))

