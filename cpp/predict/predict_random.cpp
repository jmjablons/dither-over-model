#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector predictC(NumericVector par, NumericVector reward, NumericVector side){
  double p[2] = {0, 0};
  short int n = side.size(), s, vs;
  NumericVector out(n);
  for(int i = 0; i < n; i++){
    s = side[i];
    vs = 1 - s;
    p[s] = .5;
    p[vs] = 1 - p[s];
    out[i] = p[0];}
return out;}
