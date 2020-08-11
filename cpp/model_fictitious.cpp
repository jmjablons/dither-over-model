#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector reward, NumericVector side){
  double q[2] = {0,0}, pw, nll = 0.0, beta = par[1], pe, param;
  short int n = side.size(), s, r, vs;
  param = par[0];
  for(int i = 0; i < n; i++){
    r = reward[i];
    s = side[i];
    vs = abs(s - 1);
    pw = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    pw = std::min(pw, 0.999);
    pw = std::max(pw, 0.001);
  nll += -log(pw);
  pe = r - q[s];
  q[s] += (param * pe);
  pe = (1-r) - q[vs];
  q[vs] += (param * pe);}
return nll;}
