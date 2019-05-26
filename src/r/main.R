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

chart <- f.chart.parse("src/osu/world_frag.osu")
# chart.rep <- f.replay.parse(chart, "src/feather/replay/3155787_tldne.feather")

f.decay <- function(stress, duration){
  return(stress / 1.5 ** (duration / 10000))
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
chart.bcst <- f.diff.broadcast(chart.sim,
                               ignore.types = c('lnotel'))

require(ggdark)
ggplot(chart.sim) +
  aes(x = offsets,
      y = stress) +
  geom_line(aes(group = keys,
                color = keys),
            size = 1
            ) +
  geom_smooth(aes(group = keys,
                  color = keys),
              size = 0.4,
              se = F
  ) + 
  ggtitle(label = "World Fragments",
          subtitle = "Simulated Stress by Density") +
  dark_theme_gray()

