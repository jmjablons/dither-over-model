#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector reward, NumericVector side, NumericVector session){
  double q[2] = {0,0}, pw, nll = 0.0, beta = par[1], pe;
  short int n = side.size(), s, r, vs, now, day = session[0];
  double param_pos = par[0];
  double param_neg = par[2];
  for(int i = 0; i < n; i++){
    now = session[i];
    if (now > day) {
    q[0] = q[1] = 0;
    day = session[i];}
    r = reward[i];
    s = side[i];
    vs = abs(s - 1);
    pw = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    pw = std::min(pw, 0.999);
    pw = std::max(pw, 0.001);
  nll += -log(pw);
  if (r > 0.5) {
    pe = r - q[s];
    q[s] += (param_pos * pe);
    pe = (1-r) - q[vs];
    q[vs] += (param_neg * pe);
  } else {
    pe = r - q[s];
    q[s] += (param_neg * pe);
    pe = (1-r) - q[vs];
    q[vs] += (param_pos * pe);}}
return nll;}
