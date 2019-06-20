createStaticModels <- function(chart, keyset.select,
                               mtn.across,
                               mtn.in,
                               mtn.out,
                               mtn.jack){
  chart.ext <- chartExtract(chart, keyset.select = keyset.select)
  
  
  model.jackInv.gen <- function(){
    model.jackInv(chart.ext)
  }
  model.motion.gen <- function(){
    model.motion(chart.ext,
                 suppress = T,
                 suppress.threshold = 50,
                 suppress.scale = 5,
                 directions.mapping =
                   data.frame(
                     directions = c('across', 'in', 'out', 'jack'),
                     weights = c(mtn.across, mtn.in, mtn.out, mtn.jack)
                   ))
  }
  model.density.gen <- function(){
    model.density(chart.ext,
                  window = 1000,
                  mini.ln.parse = T,
                  mini.ln.threshold = 150)
  }
  
  jck <- model.jackInv.gen()
  mtn <- model.motion.gen()
  dns <- model.density.gen()
  
  return(list("jck" = jck,
              "mtn" = mtn,
              "dns" = dns))
}
