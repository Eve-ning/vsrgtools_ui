library(reticulate)
library(ggplot2)
library(magrittr)
library(dplyr)

os <- import('os')
os$chdir('src/py/')

# from chart_parser import ChartParser
# from stress_mapper import StressMapper
#  stress_sim import StressSim
# from stress_model import StressModel
# import pandas as pd

source_python("chart_parser.py")
source_python("stress_mapper.py")
source_python("stress_sim.py")
source_python("stress_model.py")

osu.hypnotize <- "../osu/Camellia VS. lapix - Hypnotize (Evening) [bool worldwpdrive(const Entity &user);].osu"
osu.stargazer <- "../osu/stargazer - dreamer (Evening) [wander].osu"
osu.maniera <- "../osu/D(ABE3) - MANIERA (iJinjin) [Masterpiece].osu"

chart <- ChartParser(osu.maniera)
chart <- chart$parse_auto()

sm_df = data.frame(types = c('note','lnoteh','lnotet'),
                   adds = c(50, 50, 50),
                   mults = c(1, 1, 1))

smp = StressMapper(sm_df)
chart = smp$map_over(chart)

decay <- function(stress, duration) {
return(stress / (2 ** (duration / 1000)))
}

spike <- function(stress, adds, mults){
  return (stress + adds) * mults
}
smd = StressModel(decay_func = decay,
                  spike_func = spike,
                  stress = 0.0)

ss = StressSim(smd)

chart = ss.simulate(chart)


ggplot(chart) +
  aes(x = offsets,
      y = stress) +
  geom_smooth(aes(group = columns, color = factor(columns)),
              se = F)

d <- StressMapper()
