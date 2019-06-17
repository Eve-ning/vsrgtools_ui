createStaticModels <- function(chart){
  chart.bcst <- diffBroadcast(chart)
  
  model.jackInv.gen <- function(){
    model.jackInv(chart.bcst)
  }
  model.motion.gen <- function(){
    model.motion(chart.bcst,
                 keyset.select = keyset.select,
                 suppress = T,
                 suppress.threshold = 50,
                 suppress.scale = 5)
  }
  model.density.gen <- function(){
    model.density(chart,
                  window = 1000)
  }
  
  jck <- model.jackInv.gen()
  mtn <- model.motion.gen()
  dns <- model.density.gen()
  
  return(list("jck" = jck,
              "mtn" = mtn,
              "dns" = dns))
}