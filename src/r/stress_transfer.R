library(reshape2)
StressTransfer <- function(df){
  dcast(df, offsets ~ columns, value.var = stress)
  
  
}