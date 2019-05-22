f.chart.load <- function(){
  require(dplyr)
  require(tidyr)
  require(magrittr)
  require(stringr)
  require(reshape2)
  require(docstring)
  
  # Test vector
  'osu <- c(
      "CircleSize: 7",
      "[HitObjects]",
      "182,192,25029,1,0,0:0:0:66:LR_Kick Loud Bass Drop.wav",
      "109,192,25029,128,0,26779:0:0:0:100:LR3_GreatDrum.wav",
      "256,192,25029,1,0,0:0:0:33:LR_Drum Rim Fast.wav",
      "329,192,25154,128,0,25279:0:0:0:80:LR3_GreatDrum.wav",
      "402,192,25279,128,0,25404:0:0:0:40:LR_J Hit Pong.wav",
      "329,192,25404,128,0,25654:0:0:0:80:LR3_GreatDrum.wav",
      "475,192,25654,128,0,25779:0:0:0:80:LR3_GreatDrum.wav",
      "329,192,25779,128,0,25904:0:0:0:40:LR_J Hit Pong.wav",
      "402,192,25904,128,0,26029:0:0:0:80:LR3_GreatDrum.wav",
      "329,192,26029,128,0,26279:0:0:0:80:LR3_GreatDrum.wav",
      "402,192,26279,128,0,26404:0:0:0:40:LR_J Hit Pong.wav"
      )'
  
  
  f.extract <- function(osu) {
    cs.i <- pmatch('CircleSize:', osu)
    keys <<- as.integer(substr(osu[cs.i],
                                   start = 12,
                                   stop = nchar(osu[cs.i])))
    ho.i <- pmatch('[HitObjects]', osu)
    osu <- osu[ho.i+1:length(osu)]
    return(osu)
  }
  
  osu <- f.extract(osu)
  osu <- data.frame(osu, stringsAsFactors = F)
  colnames(osu) <- "txt"
  
  osu$is.ln <- str_count(string = osu$txt,
                         pattern = ":") == 5
  
  osu %<>% separate(col=txt,
                    sep=":",
                    into=c("txt","_"),
                    extra="drop")
  
  osu %<>% separate(col=txt,
                    sep=",",
                    into=c("axis",".0","offsets",".1",".2","offsets.end"))
  
  osu$keys = round((as.integer(osu$axis) * osu.keys - 256) / 512)  
  osu %<>% na.omit() 
  osu$offsets.end[osu$is.ln == F] <- NA
  osu %<>% mutate_if(is.character, as.numeric)
  
  osu <- osu[c('offsets', 'offsets.end', 'keys', 'is.ln')]
  osu$offsets.start[osu$is.ln] <- osu$offsets[osu$is.ln]
  osu$offsets[osu$is.ln] <- NA
  osu <- melt(osu, id.vars = 'keys',
              na.rm = T, variable.name = 'types',
              value.name = 'offsets')
  osu <- subset(osu, types != 'is.ln')
  return(osu)
}