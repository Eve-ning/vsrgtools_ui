library(reticulate)
library(ggplot2)
library(magrittr)
library(dplyr)

os <- import('os')
os$chdir('src/py/')
source_python("main.py")

osu.hypnotize <- "../osu/Camellia VS. lapix - Hypnotize (Evening) [bool worldwpdrive(const Entity &user);].osu"
osu.stargazer <- "../osu/stargazer - dreamer (Evening) [wander].osu"
osu.maniera <- "../osu/D(ABE3) - MANIERA (iJinjin) [Masterpiece].osu"

chart <- run_simulation(osu.maniera)

ggplot(chart) +
  aes(x = offsets,
      y = stress) +
  geom_smooth(aes(group = columns, color = factor(columns)),
              se = F)


# Create Decay and Spike Functions
def decay(stress, duration):
  return stress / (2 ** (duration / 1000))

def spike(stress, adds, mults):
  return (stress + adds) * mults

os$getcwd()
run_simulation

