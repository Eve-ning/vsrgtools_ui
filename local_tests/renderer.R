source("r/parseInput.R")
require(ggplot2)
renderPlots <- function(keyset.select, osu.dir, osu.out) {
  osu.files <- list.files(osu.dir)
  
  for (i in 1:length(osu.files)) {
    if (!file.exists(paste0(osu.out, osu.files[i], '.jpg')))
    {
        output <- parseInput(chart.path = paste0(osu.dir, osu.files[i]),
                             make.plot = T,
                             plot.title = osu.files[i],
                             keyset.select = keyset.select,
                             lim.hist = 15,
                             lim.line = 40,
                             rate = 1.0)
        ggsave(filename = paste0(osu.out, osu.files[i], '.jpg'),
               plot = output$plt, width = 14, height = 7)
    } else {}
  }
}

renderPlots('4', 'local_tests/osu/4/')



render.7K <- function() {
  osu.dir <- "local_tests/osu/7/"
  osu.out <- "local_tests/osu_plots/7/"
  osu.files <- list.files(osu.dir)
  
  for (i in 1:length(osu.files)) {
    if (!file.exists(paste0(osu.out, osu.files[i], '.jpg')))
    {
      output <- parseInput(chart.path = paste0(osu.dir, osu.files[i]),
                           keyset.select = '7R',
                           make.plot = T,
                           plot.title = osu.files[i],
                           lim.hist = 15,
                           lim.line = 50,
                           rate = 1.0)
      ggsave(filename = paste0(osu.out, osu.files[i], '.jpg'),
             plot = output$plt, width = 14, height = 7)
    } else {}
  }
}

render.4K()
render.7K()
