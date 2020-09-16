#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector side, NumericVector win, NumericVector stay){
  double p[2] = {0.5, 0.5}, nll = 0.0;
  short int n = side.size(), s, wi, st;
  for(int i = 0; i < n; i++){
    s = side[i];
    wi = win[i];
    st = stay[i];
    if ((wi > 0.1 && st > 0.1) || (wi < 0.1 && st < 0.1)) {
      p[s] = 1 - (par[0]/2);}
    if ((wi > 0.1 && st < 0.1) || (wi < 0.1 && st > 0.1)) {
      p[s] = 0 + (par[0]/2);}
    p[s] = std::min(p[s], 0.999);
    p[s] = std::max(p[s], 0.001);
nll += -log(p[s]);}
return nll;}
