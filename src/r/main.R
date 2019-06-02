library(ggplot2)
library(feather)
library(reshape2)
library(zoo)
library(dplyr)
library(magrittr)
library(microbenchmark)
{
source("src/r/chart_parser.R")
source("src/r/stress_sim.R")
source("src/r/replay_parser.R")
source("src/r/diff_broadcast.R")
source("src/r/move_mapping.R")
source("src/r/alpha_calc.R")
}
microbenchmark(
  "al" = {
  # Chart Parser
    chart.path <- 'src/osu/tldne.osu'
    chart <- f.chart.parse(chart.path)
  
  # Replay Parser
    chart.rep <- f.replay.parse(chart, "src/feather/replay/3155787_tldne.feather",
                                ignore.threshold = 100)
    chart.rep %<>%
      aggregate(devs ~ offsets, data = ., mean)
  
  # Stress Simulation
    f.stress.decay <- function(stress, duration){
      return(stress / 1.5 ** (duration / 10000))
    }
    f.stress.spike <- function(stress, args){
      return((stress + args$adds) / args$mults)
    }
    stress.mapping <-
      data.frame(types = c("note", "lnoteh", "lnotel"),
                 adds  = c(0.5, 0.5, 0.2),
                 mults = c(1,1,1))
    chart.sim <- f.stress.sim(chart = chart,
                              f.spike = f.stress.spike,
                              f.decay = f.stress.decay,
                              df.mapping = stress.mapping,
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
                                f.create.move.mapping(keyset.select),
                                f.alpha)
  }
, times = 2
)



chart.custom.stress <- chart.sim %>% 
  aggregate(stress ~ offsets, data=., median)

chart.custom.stress %<>%
  merge(chart.rep, by = 'offsets')


cor(chart.custom.stress$stress, chart.custom.stress$devs)

ggplot(chart.custom.stress) +
  aes(x = offsets,
      y = stress) +
  geom_point() +
  geom_line(aes(y = devs), color="blue")

ggplot(chart.alpha) +
  aes(x=offsets,
      y=alphas) +
  geom_point()
