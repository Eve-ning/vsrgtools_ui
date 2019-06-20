# This will use d.mdl once it's done
# calculateDifficulty <- function(s.mdls, dif.quant, dif.quant.type){
#   jck <- quantile(s.mdls$jck$jack.invs, dif.quant, type = dif.quant.type)
#   mtn <- quantile(s.mdls$mtn$diffs.invs, dif.quant, type = dif.quant.type)
#   dns <- quantile(s.mdls$dns$counts, dif.quant, type = dif.quant.type)
#   
#   return(list("jck" = round(jck * 2000, 2),
#               "mtn" = round(mtn * 1000, 2),
#               "dns" = dns))
# }
