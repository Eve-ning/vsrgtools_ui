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

chart <- f.chart.parse('src/osu/aiae.osu')
# chart.rep <- f.replay.parse(chart, "src/feather/replay/3155787_tldne.feather")

{ # Simulate
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
}

# broadcast on diff
chart.bcst <- f.diff.broadcast(chart.sim,
                               ignore.types = c('lnotel'))

{ # Get Alpha
  move.mapping <- f.create.move.mapping(keyset.select = '4')

  f.alpha <- function(diffs, moves){
    return(moves * (1/diffs))
  }
  chart.alpha <- f.alpha.calc(chart.bcst, move.mapping, f.alpha)
}

require(ggdark) 

chart.alpha$keys.move = paste(as.character(chart.alpha$keys.froms),
                              as.character(chart.alpha$keys.tos),
                              sep = '->')

chart.alpha$bins <- (chart.alpha$offsets %/% 500) * 500
chart.alpha.n <- subset(chart.alpha, chart.alpha$keys.froms == chart.alpha$keys.tos)
chart.alpha.n <- 
  aggregate(diffs ~ bins,
            data=chart.alpha.n,
            FUN=mean)

ggplot(subset(chart.alpha.n, chart.alpha.n$diffs < 1000)) +
  aes(x = bins,
      y = diffs) +
  geom_point() +
  geom_line() +
  dark_theme_minimal() +
  ylim(0,1000) +
  xlab('offsets') +
  ggtitle("AiAe SHD Jack Speed Analysis")

# Generate Broadcasted.
ggplot(chart.bcst.k.d) +
  aes(x=offsets,
      y=diffs) +
  geom_bar(stat = 'identity',
           aes(group=diff.types,
               color=diff.types),
           show.legend = F) +
  dark_theme_minimal() +
  facet_wrap(~keys, ncol=2)


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

