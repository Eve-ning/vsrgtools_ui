# This file is used to load in feathers and plot it because
# Python plotting is way too hard

library(ggplot2)
library(feather)
library(reshape2)
library(zoo)
library(dplyr)
library(magrittr)

'source("src/r/stress_transfer.R")'

# Define all functions here
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
f.project.values <- function(df.map.str){
  df.mapc <- dcast(df.map.stress, offsets ~ columns, value.var = "stress")
  df.mapc <- as.data.frame(na.approx(df.mapc))
  df.mapc[is.na(df.mapc)] <- 0
  df.map.str <- melt(df.mapc,
                     id.vars = 1,
                     value.name = "stress",
                     variable.name = "columns")
  return(df.map.str)
}

f.load.feathers("tldne",
                3155787)
{ # This chunk deals with simulated stress
  df.map.stress <- f.project.values(df.map.stress)
  df.map.stress <- 
    group_by(df.map.stress, offsets) %>% 
    summarise(
      stress.85 = quantile(stress, probs = 0.85),
      stress.50 = quantile(stress, probs = 0.50),
      stress.15 = quantile(stress, probs = 0.15)
    ) %>% 
    melt(id.vars = 1,
         value.name = "stress",
         variable.name = "quantiles")
}
{ # This chunk deals with replay stress/dev
  # This creates the action column for map
  df.map$actions <- df.map$columns + 1
  df.map$actions[df.map$types == 'lnotet'] %<>%
   multiply_by(-1)
  
  # Does a similarity match between 2 DataFrames
  df.match <- f.similarity.match(df.map = df.map,
                                 df.replay = df.replay)
  
  # Calculate deviation
  df.match$dev <- df.match$r.offsets - df.match$offsets
  
  df.match$bin.s <- ceiling(df.match$offsets / 1000) * 1000
  df.match$dev <- abs(df.match$dev)
  df.match <- df.match %>%  
    group_by(bin.s) %>% 
    summarise(
      dev.85 = quantile(dev, probs = 0.85),
      dev.50 = quantile(dev, probs = 0.50),
      dev.15 = quantile(dev, probs = 0.15)
    ) %>% 
    melt(id.vars = 1,
         value.name = "dev",
         variable.name = "quantiles")
 
}

colnames(df.match) <- c("offsets", "quantiles", "stress")
df.match$stress <- df.match$stress * 25
df.temp <- rbind(df.map.stress, df.match)

ggplot(df.map.stress) +
  aes(x = offsets, y = stress) +
  geom_smooth(aes(group=quantiles,
                  color=quantiles),se=F) +
  ggtitle(label = "Cardboard Box - The Limit Does Not Exist (Infinity)",
          subtitle = "Simulated Stress by Virtual Player") +
  xlab("offset") +
  ylab("stress")

  
ggplot(df.match) +
  aes(x = bin.s, y = dev) +
  geom_smooth(span=0.3,
              aes(group=quantiles,
                  color=quantiles), se=F,
              linetype='longdash') +
  ggtitle(label = "Cardboard Box - The Limit Does Not Exist (Infinity)",
          subtitle = "Play by MoTeSolo") +
  xlab("offset") +
  ylab("|dev|")


