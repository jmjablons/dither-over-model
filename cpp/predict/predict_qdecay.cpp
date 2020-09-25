#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector predictC(NumericVector par, NumericVector reward, NumericVector side, NumericVector interval){
  double q[2] = {0,0}, p[2] = {0, 0}, beta = par[1], pe, decay = par[2], t;
  short int n = side.size(), s, vs, r;
  NumericVector out(n);
  for(int i = 0; i < n; i++){
  r = reward[i];
  s = side[i];
  t = interval[i];
  vs = 1 - s;
  q[s] = exp(0-(t * decay)) * q[s];
  q[vs] = exp(0-(t * decay)) * q[vs];
  p[s] = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
  p[s] = std::min(p[s], 0.999);
  p[s] = std::max(p[s], 0.001);
  p[vs] = 1 - p[s];
  out[i] = p[0];
  pe = r - q[s];
  q[s] += (par[0] * pe);}
return out;}
