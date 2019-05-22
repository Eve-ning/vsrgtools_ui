

source("src/r/chart_parser.R")
source("src/r/stress_sim.R")

chart <- f.chart.parse("src/osu/tldne.osu")

f.decay <- function(stress, duration){
  return(stress / 2 ** (duration / 1000))
}

f.spike <- function(stress, args){
  return((stress + args$adds) / args$mults)
}

df.mapping <-
  data.frame(types = c("note", "lnoteh", "lnotel"),
             adds  = c(50, 50, 20),
             mults = c(1,1,1))

chart.sim <- f.stress.sim(chart = chart,
                          f.spike = f.spike,
                          f.decay = f.decay,
                          df.mapping = df.mapping,
                          stress.init = 0)

library(ggplot2)

ggplot(chart.sim) +
  aes(x = offsets,
      y = stress.decay) +
  geom_line(aes(group = keys,
                color = keys))
