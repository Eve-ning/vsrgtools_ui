createComparisonPlot <- function(s.mdls,
                                 lim.hist,
                                 lim.line,
                                 span,
                                 plot.title){
  
  require(ggplot2)
  require(ggpubr)
  
  p.jck <- ggplot(s.mdls$jck) +
    aes(jack.invs * 1000) +
    geom_histogram(bins = 25) +
    xlab("Jack Difficulty") +
    ylab("Frequency") +
    ggtitle(plot.title)
  
  p.mtn <- ggplot(s.mdls$mtn) +
    aes(diffs.invs * 1000) +
    geom_histogram(bins = 25) +
    xlab("Motion Difficulty") +
    ylab("Frequency") 
  
  require(dplyr)
  require(magrittr)
  dns <- s.mdls$dns %>% 
    filter(types %in% c('m.lnoteh', 'lnoteh', 'note'))
  
  p.dns <- ggplot(dns) +
    aes(offsets, counts) +
    stat_smooth(geom = 'area', span = span, method = 'loess', position = "stack") +
    xlab("Offsets") +
    ylab("Density Difficulty") 
  
  p.jck <- p.jck +
    aes(fill = keys) +
    facet_wrap(. ~ keys, nrow = 1)
  
  p.mtn <- p.mtn +
    aes(fill = (paste(fngs.tos)),
        group = paste(fngs.tos, fngs.froms)) +
    facet_wrap(. ~ fngs.froms, nrow = 1)
  
  p.dns <- p.dns +
    aes(fill = types,
        group = types) 
  
  if (!is.na(lim.hist)){
    p.jck <- p.jck +
      coord_cartesian(xlim=c(0, lim.hist))
    p.mtn <- p.mtn +
      coord_cartesian(xlim=c(0, lim.hist))
  }
  
  if (!is.na(lim.line)){
    p.dns <- p.dns  +
      coord_cartesian(ylim=c(0, lim.line))
  }
  
  plt <- ggarrange(p.jck, p.mtn, p.dns, nrow = 3) 
  
  return(plt)
  
}