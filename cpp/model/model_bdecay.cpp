#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector reward, NumericVector side, NumericVector interval){
  double q[2] = {0,0}, pw, nll = 0.0, beta0 = par[1], pe, decay = par[2], t, beta;
  short int n = side.size(), s, r;
  for(int i = 0; i < n; i++){
    r = reward[i];
    s = side[i];
    t = interval[i];
    beta = exp(0-(t * decay)) * (beta0);
    pw = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    pw = std::min(pw, 0.999);
    pw = std::max(pw, 0.001);
    nll += -log(pw);
    pe = r - q[s];
    q[s] += (par[0] * pe);}
return nll;}
