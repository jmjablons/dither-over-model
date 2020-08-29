#include <Rcpp.h>
#include <cmath>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector reward,
  NumericVector side, NumericVector session){
  double q[2] = {0,0}, pw, nll = 0.0, beta = par[1], pe, mi = par[2], alpha, alpha0 = par[0];
  short int n = side.size(), s, now, day = session[0];
  alpha = alpha0;
  for(int i = 0; i < n; i++){
    now = session[i];
    if (now > day) {
    q[0] = q[1] = 0;
    day = session[i];}
    s = side[i];
    pw = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    pw = std::min(pw, 0.999);
    pw = std::max(pw, 0.001);
  nll += -log(pw);
  pe = reward[i] - q[s];
  alpha = (mi * abs(pe)) + ((1 - mi) * alpha0);
  q[s] += (alpha * pe);}
return nll;}
