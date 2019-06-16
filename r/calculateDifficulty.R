# This function will generate plots based on chart.path

calculateDifficulty <- function(chart.lines,
                                keyset.select,
                                span = 0.1,
                                rate = 1.0,
                                is.summarised = T,
                                lim.jck = NA,
                                lim.mtn = NA,
                                lim.dns = NA,
                                dif.quant = 0.85){
  
  require(osutools)
  require(magrittr)
  require(dplyr)
  require(ggplot2)
  require(ggpubr)
  
  start.time <- Sys.time()
  
  chart <- chartParse(chart.lines = chart.lines)
  
  chart %<>% mutate(offsets = offsets / rate)
  chart.bcst <- diffBroadcast(chart)
  
  model.jackInv.gen <- function(){
    model.jackInv.fun <- function(jack.invs) {
      return(max(jack.invs) + mean(jack.invs) * 0.25)
    }
    
    model.jackInv(chart.bcst,
                  is.summarised = is.summarised,
                  summarised.fun = model.jackInv.fun)
  }
  model.motion.gen <- function(){
    model.motion.fun <- function(diffs.invs, keys.froms, keys.tos) {
      # keys.mid <- max(keys.froms) / 2
      # df <- data.frame(
      #   diffs.invs = diffs.invs,
      #   keys.froms = keys.froms - keys.mid,
      #   keys.tos = keys.tos - keys.mid
      # )
      # 
      # df %<>%
      #   mutate(is.diff.hand = ((keys.froms * keys.tos) < 0),
      #          keys.froms = abs(keys.froms),
      #          keys.tos = abs(keys.tos),
      #          adjust = ifelse(keys.tos < keys.froms & (!is.diff.hand), 1.5, 1.0),
      #          out = adjust * diffs.invs)
      
      # return(max(df$out) + mean(df$out) * 0.25)
      return(1)
    }
    model.motion(chart.bcst,
                 keyset.select = keyset.select,
                 suppress = T,
                 suppress.threshold = 50,
                 suppress.scale = 5,
                 is.summarised = is.summarised,
                 summarised.num.fun = model.motion.fun)
  }
  model.density.gen <- function(){
    model.density.df <- data.frame(
      types = c('lnotel', 'lnoteh', 'note'),
      adjusts = c(0.5, 1.0, 1.0)
    )
    model.density.fun <- function(counts, types) {
      # df <- data.frame(
      #   counts = counts,
      #   types = types
      # )
      # df %<>% merge(model.density.df) %>% 
      #   mutate(output = counts * adjusts)
      # 
      # return(sum(df$output))
      return(1)
    }
    
    model.density(chart,
                  window = 1000,
                  is.summarised = is.summarised,
                  summarised.fun = model.density.fun)
  }

  model.plot.gen <- function(jck, mtn, dns){
    p.jck <- ggplot(jck) +
      aes(offsets, jack.invs) +
      geom_smooth(se = F, method = 'loess', span = span) +
      ylab("Jack Difficulty")
    
    p.mtn <- ggplot(mtn) +
      aes(offsets, diffs.invs) +
      geom_smooth(se = F, method = 'loess', span = span) +
      ylab("Motion Difficulty") 
    
    p.dns <- ggplot(dns) +
      aes(offsets, counts) +
      geom_smooth(se = F, method = 'loess', span = span) +
      ylab("Density Difficulty") 
    
    
    if(!is.summarised) {
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
    }
    
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
  model.diff.gen <- function(jck, mtn, dns){
    jck <- quantile(jck$jack.invs, dif.quant)
    mtn <- quantile(mtn$diffs.invs, dif.quant)
    dns <- quantile(dns$counts, dif.quant)
    result <- paste0("Jack: ", round(jck * 1000,2),
                     " Motion: ", round(mtn * 1000,2),
                     " Density: ", round(dns, 2),
                     " Sum: ", round(jck * 1000 + mtn * 1000 + dns, 2))
    return(result)
  }
  
  jck <- model.jackInv.gen()
  mtn <- model.motion.gen()
  dns <- model.density.gen()
  
  plt <- model.plot.gen(jck, mtn, dns)
  dif <- model.diff.gen(jck, mtn, dns)
  
  end.time <- Sys.time()
  dly = end.time - start.time
  return(list("plt" = plt,
              "jck" = jck,
              "dns" = dns,
              "mtn" = mtn,
              "dif" = dif,
              "dly" = dly))
}
