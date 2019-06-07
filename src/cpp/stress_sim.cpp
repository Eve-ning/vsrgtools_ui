#include <Rcpp.h>
using namespace Rcpp;

// Simulates the chart on CPP rather than R
// Types Accepted:
// Pad, Spike, Decay

// Note that separate keys should be passed in different instances
// Can probably add a wrapper function to handle that
// V1: Stress Value before Spike (Including Decay)
// V2: Stress Value after Spike (Excluding Decay)
List simulate_key(NumericVector offsets,
                  LogicalVector is_spikes,
                  List args_list,
                  Function spike_func,
                  Function decay_func,
                  double stress = 0.0) {
  
  unsigned int rows = offsets.length();
  
  // Initialize with -1 as default
  NumericVector stress_base(rows, -1.0);
  NumericVector stress_spike(rows, -1.0);
  
  double offset_buffer = 0.0;
  double offset = 0.0;
  double duration = 0.0;
  bool is_spike = false;
  
  for (unsigned int row; row < rows; row ++) {
    // Get all the required parameters
    offset = offsets[row];
    is_spike = is_spikes[row];
    duration = offset - offset_buffer; 
    
    // If spike, we will calculate via decay then spike_func
    // and commit into stress var.
    // Else, will calculate via decay_func but do not commit.
    
    // This conditional is reversed since non-spikes are more
    // common
    if (!is_spike){
      stress_base[row] = as<double>(decay_func(_["stress"] = stress,
                                               _["duration"] = duration,
                                               _["args"] = args_list["decay"]));
    } else {
      stress = as<double>(spike_func(_["stress"] = stress,
                                     _["args"] = args_list["decay"]));
      stress_base[row] = stress;
      stress = as<double>(decay_func(_["stress"] = stress,
                                     _["duration"] = duration,
                                     _["args"] = args_list["spike"]));
      stress_spike[row] = stress;
    }

    offset_buffer = offset;
  }
  
  List stress_list = List::create(
    _["base"] = stress_base,
    _["spike"] = stress_spike
  );
  
  return stress_list;
}