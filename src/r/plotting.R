# This file is used to load in feathers and plot it because
# Python plotting is way too hard

library(ggplot2)
library(feather)
library(reshape2)
library(zoo)
library(dplyr)
library(magrittr)

'source("src/r/stress_transfer.R")'

map_name <- "tokio_funka"

f.load.feathers <- function(map.name, user.id){
  feather.map.path <- "src/feather/map/"
  feather.replay.path <- "src/feather/replay/"
  df.map <<- read_feather(paste(feather.map.path,
                               map.name,
                               ".feather",
                               sep = ""))
  df.map.stress <<- read_feather(paste(feather.map.path,
                                      map.name,
                                      "_stress.feather",
                                      sep = ""))
  df.replay <<- read_feather(paste(feather.replay.path,
                                  user.id,
                                  "_",
                                  map.name,
                                  ".feather",
                                  sep = ""))
}
f.similarity.match <- function(df.map, df.replay){
  actions.unq <- unique(df.map$actions)
  
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
                                                      df.map.ac$offsets[ac.m]))[1],]
      colnames(df.replay.match) <- paste("r",
                                         colnames(df.replay.match),
                                         sep='.')
      df.match <- cbind(df.replay.match, df.map.ac[ac.m,])
      df.joined <- rbind(df.joined, df.match)
    }
  }
  
  return(df.joined)
}

# This creates the action column for map
df.map$actions <- df.map$columns + 1
df.map$actions[df.map$types == 'lnotet'] %<>%
 multiply_by(-1)

# Does a similarity match between 2 DataFrames
df.match <- f.similarity.match(df.map = df.map,
                               df.replay = df.replay)

# Calculate deviation
df.match$dev <- df.match$r.offsets - df.match$offsets

df.temp <- aggregate(dev ~ offsets, data = df.match, mean)

df.mapc <- dcast(df.map.stress, offsets ~ columns, value.var = "stress")
df.mapc <- as.data.frame(na.approx(df.mapc))
df.mapc[is.na(df.mapc)] <- 0
df.mapc$stress <- rowMeans(df.mapc[,2:ncol(df.mapc)])
# This takes into account the generated stress, we need to remove that as well

normalize <- function(x){(x-min(x))/(max(x)-min(x))}
zero <- function(x){x - mean(x)}
df.mapc$stress.zero <- df.mapc$stress %>% zero()
df.temp$stress.norm <- df.temp$dev %>% normalize()

ggplot(df.mapc) +
  aes(x = offsets, y = stress) +
  geom_smooth(legend = "test") +
  geom_point(data = df.temp,
              aes(x = offsets, y = dev),
              color='red')


