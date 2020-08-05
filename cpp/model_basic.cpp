#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector reward, NumericVector side){
  double q[2] = {0,0}, pw, nll = 0.0, beta = par[1], pe;
  short int n = side.size(), s;
  for(int i = 0; i < n; i++){
    s = side[i];
    pw = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    pw = std::min(pw, 0.999);
    pw = std::max(pw, 0.001);
  nll += -log(pw);
  pe = reward[i] - q[s];
  q[s] += (par[0] * pe);}
return nll;}
