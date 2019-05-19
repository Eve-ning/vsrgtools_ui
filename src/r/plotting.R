# This file is used to load in feathers and plot it because
# Python plotting is way too hard

library(ggplot2)
library(feather)
library(reshape2)
library(zoo)
library(dplyr)
library(magrittr)

'source("src/r/stress_transfer.R")'

feather.map.path <- "src/feather/map/"
feather.replay.path <- "src/feather/replay/"

df.map <- read_feather(paste(feather.map.path,
                             "maniera.feather",
                             sep = ""))
df.replay <- read_feather(paste(feather.replay.path,
                                "manieraJupiter.feather",
                                sep = ""))

df.map$actions <- df.map$columns
df.map$actions[df.map$types == 'lnotet'] %<>%
 multiply_by(-1)

actions.unq <- unique(df.map$actions)

f.similarity.match <- function(df.map, df.replay){
  
  df.joined <- data.frame(matrix(ncol=8, nrow=0))
  for (ac in actions.unq) {
    df.map.ac <- subset(df.map, actions == ac)
    df.replay.ac <- subset(df.replay, actions == ac)
    
    for (ac.m in 1:nrow(df.map.ac)) {
      # From all offsets of the replay df, we will deduct a looped
      # map df offset
      # We will get the minimum (which is the closest match)
      # Then we throw it into df.joined
      df.replay.match <- df.replay.ac[which.min(abs(df.replay.ac$offsets -
                                                    df.map.ac$offsets[ac.m])),]
      colnames(df.replay.match) <- paste("r",
                                         colnames(df.replay.match),
                                         sep='.')
      df.match <- cbind(df.replay.match, df.map.ac[ac.m,])
      df.joined <- rbind(df.joined, df.match)
    }
  }
  
  return(df.joined)
}
group_by(df.replay, by=action)

df.mapc <- dcast(df.map, offsets ~ columns, value.var = "stress")
df.mapc <- as.data.frame(na.approx(df_mapc))

df.replayc <- dcast(df.replay, offsets ~ columns, value.var = "stress")

ggplot(df_mapc) +
  aes(x = offsets, y = `1`) +
  geom_smooth(se = F)

