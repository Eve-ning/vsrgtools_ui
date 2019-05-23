f.chart.parse <- function(chart.path){
  #' Parses the chart into a data.frame
  #' 
  #' Only .osu formats are supported for now.
  #' 
  #' @param chart.path Path of the chart to be parsed
  #' @return A data.frame consisting of the note's data only.
  #' Columns: keys, types, offsets
  
  chart.f = file(chart.path, open='r')
  chart = readLines(chart.f)
  
  f.chart.parse.osu <- function(chart) {
    #' Parses the osu chart into a data.frame
    #' 
    #' @param chart The chart to be parsed, in a vector of characters.
    #' This can be provided via readLines function.
    #' 
    require(dplyr)
    require(tidyr)
    require(magrittr)
    require(stringr)
    require(reshape2)
    require(docstring)
    
    f.extract <- function(chart) {
      cs.i <- pmatch('CircleSize:', chart)
      keys <- as.integer(substr(chart[cs.i],
                                start = 12,
                                stop = nchar(chart[cs.i])))
      ho.i <- pmatch('[HitObjects]', chart)
      chart <- chart[ho.i+1:length(chart)]
      return(list("chart" = chart, "keys" = keys))
    }
    
    extract <- f.extract(chart)
    chart <- extract$chart
    keys <- extract$keys
    
    chart <- data.frame(chart, stringsAsFactors = F)
    colnames(chart) <- "txt"
    
    chart$is.ln <- str_count(string = chart$txt,
                             pattern = ":") == 5
    
    chart %<>% separate(col=txt,
                        sep=":",
                        into=c("txt","_"),
                        extra="drop")
    
    chart %<>% separate(col=txt,
                        sep=",",
                        into=c("axis",".0","note",".1",".2","lnotel"))
    
    chart$keys = round((as.integer(chart$axis) * keys - 256) / 512) + 1
    chart %<>% na.omit() 
    chart$lnotel[chart$is.ln == F] <- NA
    chart %<>% mutate_if(is.character, as.numeric)
    
    chart <- chart[c('note', 'lnotel', 'keys', 'is.ln')]
    chart$lnoteh[chart$is.ln] <- chart$note[chart$is.ln]
    chart$note[chart$is.ln] <- NA
    chart <- melt(chart, id.vars = 'keys',
                  na.rm = T, variable.name = 'types',
                  value.name = 'offsets')
    chart <- subset(chart, types != 'is.ln')
    return(chart)
  }
  
  # To add a switch/ifelse statement if more formats are done
  return(f.chart.parse.osu(chart))
}


# # Test vector
# chart <- c(
#   "CircleSize: 7",
#   "[HitObjects]",
#   "182,192,25029,1,0,0:0:0:66:LR_Kick Loud Bass Drop.wav",
#   "109,192,25029,128,0,26779:0:0:0:100:LR3_GreatDrum.wav",
#   "256,192,25029,1,0,0:0:0:33:LR_Drum Rim Fast.wav",
#   "329,192,25154,128,0,25279:0:0:0:80:LR3_GreatDrum.wav",
#   "402,192,25279,128,0,25404:0:0:0:40:LR_J Hit Pong.wav",
#   "329,192,25404,128,0,25654:0:0:0:80:LR3_GreatDrum.wav",
#   "475,192,25654,128,0,25779:0:0:0:80:LR3_GreatDrum.wav",
#   "329,192,25779,128,0,25904:0:0:0:40:LR_J Hit Pong.wav",
#   "402,192,25904,128,0,26029:0:0:0:80:LR3_GreatDrum.wav",
#   "329,192,26029,128,0,26279:0:0:0:80:LR3_GreatDrum.wav",
#   "402,192,26279,128,0,26404:0:0:0:40:LR_J Hit Pong.wav"
# )

