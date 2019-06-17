createComparisonPlot <- function(s.mdls,
                                 lim.jck,
                                 lim.mtn,
                                 lim.dns){
  
  require(ggplot2)
  require(ggpubr)
  
  p.jck <- ggplot(s.mdls$jck) +
    aes(offsets, jack.invs) +
    geom_smooth(se = F, method = 'loess', span = span) +
    ylab("Jack Difficulty")
  
  p.mtn <- ggplot(s.mdls$mtn) +
    aes(offsets, diffs.invs) +
    geom_smooth(se = F, method = 'loess', span = span) +
    ylab("Motion Difficulty") 
  
  p.dns <- ggplot(s.mdls$dns) +
    aes(offsets, counts) +
    geom_smooth(se = F, method = 'loess', span = span) +
    ylab("Density Difficulty") 
  
  p.jck <- p.jck +
    aes(color = keys) +
    facet_wrap(. ~ keys, nrow = 1)
  
  p.mtn <- p.mtn +
    aes(color = (paste(tos)),
        group = paste(tos, froms)) +
    facet_wrap(. ~ froms, nrow = 1) 
  
  p.dns <- p.dns +
    aes(color = types,
        group = types)
  
  if (!is.na(lim.jck)){
    p.jck <- p.jck + coord_cartesian(ylim=c(0, lim.jck))
  }
  
  if (!is.na(lim.mtn)){
    p.mtn <- p.mtn + coord_cartesian(ylim=c(0, lim.mtn))
  }
  
  if (!is.na(lim.dns)){
    p.dns <- p.dns + coord_cartesian(ylim=c(0, lim.dns))
  }
  
  plt <- ggarrange(p.jck, p.mtn, p.dns, nrow = 3)
  
  return(plt)
  
}