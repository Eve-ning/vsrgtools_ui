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

f.stress.decay <- function(stress, duration){
  return(stress / 1.5 ** (duration / 10000))
}
f.stress.spike <- function(stress, args){
  return((stress + args$adds) / args$mults)
}
f.alpha <- function(diffs, moves.values){
  return(moves.values * (1/diffs))
}
stress.mapping <-
  data.frame(types = c("note", "lnoteh", "lnotel"),
             adds  = c(50, 50, 20),
             mults = c(1,1,1))
chart.path <- 'src/osu/aiae.osu'
keyset.select <- '4'

chart <- f.chart.parse(chart.path)
chart.sim <- f.stress.sim(chart = chart,
                          f.spike = f.stress.spike,
                          f.decay = f.stress.decay,
                          df.mapping = stress.mapping,
                          stress.init = 0)

# Stress is lost here
# broadcast on diff
chart.bcst <- f.diff.broadcast(chart.sim,
                               ignore.types = c('lnotel'))

move.mapping <- f.create.move.mapping(keyset.select)
chart.alpha <- f.alpha.calc(chart.bcst, move.mapping, f.alpha)


require(ggdark) 

chart.alpha$bins <- (chart.alpha$offsets %/% 1000) * 1000
chart.alpha$keys.moves <- paste(as.character(chart.alpha$keys.froms),
                                as.character(chart.alpha$keys.tos),
                                sep = "->")
chart.alpha.n <- 
  aggregate(diffs ~ bins + keys.moves,
            data=chart.alpha,
            FUN=min)

ggplot(chart.alpha.n) +
  aes(x = bins,
      y = diffs) +
  geom_point(size=0.7) +
  dark_theme_minimal() +
  ylim(0,250) +
  xlab('offsets') +
  facet_wrap(~keys.moves,ncol=4)
