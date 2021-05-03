#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector reward, NumericVector side){
  double q[2] = {0,0}, pw, nll = 0.0,  pe;
  short int n = side.size(), s, r, vs;
  double param_real = par[0], beta = par[1], param_fict = par[2];
  for(int i = 0; i < n; i++){
    r  = reward[i];
    s  = side[i];
    vs = abs(s - 1);
    pw = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    pw = std::min(pw, 0.999);
    pw = std::max(pw, 0.001);
  nll += -log(pw);
  if (r > 0.5) {
    pe     = r - q[s];
    q[s]  += (param_real * pe);
    pe     = r - q[vs];
    q[vs] += (param_fict * pe);
  } else {
    pe     = (1-r) - q[s];
    q[s]  += (param_real * pe);
    pe     = (1-r) - q[vs];
    q[vs] += (param_fict * pe);}}
return nll;}
