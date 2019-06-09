#include <Rcpp.h>
using namespace Rcpp;

// This will be accepting a resetsFrame of
// Input
  // offsets must just be a NumericVector of the offsets
  // resets must a LogicalMatrix of the presence of the
  //  broadcasted notes, where broadcasting must reset.
  
// [[Rcpp::export]]  
NumericMatrix broadcast(NumericVector offsets,
                        LogicalMatrix resets){
  
  unsigned int rows = offsets.length();
  
  assert((rows != resets.length(),
          "Number of rows of offsets and resets must match."));
  
  unsigned int keys = resets.ncol();
  
  NumericVector trackers(keys, 0); 
  LogicalVector resets_row(keys, 0);
  
  // This is a preallocated output matrix
  NumericMatrix data(resets.nrow(), resets.ncol(), 0);
  
  double offset_buffer = 0.0;
  double offset = 0.0;
  double offset_diff = 0.0;
  
  for (unsigned int row = 0; row < rows; row ++) {
    offset = offsets[row];
    resets_row = resets[row];
    offset_diff = offset_buffer - offset;
    
    trackers = trackers + offset_diff;
    
    data(row,_) = trackers;
    
    for (unsigned int reset = 0; reset < keys; reset ++) {
      if (resets[reset]) {
        trackers = 0;
      }
    }
    
    offset_buffer = offset;
  }
  
  return data;
};