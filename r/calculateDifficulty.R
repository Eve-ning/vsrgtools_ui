# This will use d.mdl once it's done
calculateDifficulty <- function(s.mdls){
  jck <- quantile(s.mdls$jck$jack.invs, dif.quant)
  mtn <- quantile(s.mdls$mtn$diffs.invs, dif.quant)
  dns <- quantile(s.mdls$dns$counts, dif.quant)
  
  result <- paste0("Jack: ", round(jck * 1000,2),
                   " Motion: ", round(mtn * 1000,2),
                   " Density: ", round(dns, 2),
                   " Sum: ", round(jck * 1000 + mtn * 1000 + dns, 2))
  return(result)
}
