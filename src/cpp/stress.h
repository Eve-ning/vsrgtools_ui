#include <Rcpp.h>
#include <map>
using namespace std;
using namespace Rcpp;

class Stress {
public:
  Stress(double stress,
         string decay_mode = "pow",
         string spike_mode = "add");
  
  double stress() const;
  void stress(double val);
  
  map<string, double (*)(double)> decay_modes = {
    {"pow"}
  };
  
  
  void decay(double (*f)(double));
  void spike(double (*f)(double));
  
private:
  double m_stress;
};

