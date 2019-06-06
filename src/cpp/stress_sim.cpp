#include <Rcpp.h>
using namespace Rcpp;

// Note that separate keys should be passed in different instances
// Can probably add a wrapper function to handle that
// V1: Stress Value before Spike (Including Decay)
// V2: Stress Value after Spike (Excluding Decay)
List simulate_key(NumericVector offset_v,
                  NumericVector key_v,
                  List args,
                  Function spike,
                  Function decay,
                  unsigned int keys,
                  double stress = 0) {
  
  unsigned int rows = offset_v.length();
  
  NumericVector stress_decay(rows);
  NumericVector stress_spike(rows);
  NumericVector stress_trackers(keys);
  
  for (unsigned int row; row < rows; row ++) {
    stress = spike();
  }
  
  
}