#include <Rcpp.h>
#include <cmath>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector predictC(NumericVector par, NumericVector reward, NumericVector side){
  double q[2] = {0,0}, p[2] = {0, 0}, beta = par[1], pe, mi = par[2], alpha, alpha0 = par[0];
  short int n = side.size(), s, vs;
  NumericVector out(n);
  alpha = alpha0;
  for(int i = 0; i < n; i++){
    s = side[i];
    vs = 1-s;
    p[s] = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    p[s] = std::min(p[s], 0.999);
    p[s] = std::max(p[s], 0.001);
    p[vs] = 1 - p[s];
    out[i] = p[0];
  pe = reward[i] - q[s];
  alpha = (mi * abs(pe)) + ((1 - mi) * alpha0);
  q[s] += (alpha * pe);}
return out;}
