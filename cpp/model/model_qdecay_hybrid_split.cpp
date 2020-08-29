#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector reward, NumericVector side, NumericVector interval){
  double q[2] = {0,0}, pw, nll = 0.0, beta = par[1], pe, decay, t;
  short int n = side.size(), s, r, vs, rev[2] = {0,0};
  double param_pos = par[0];
  double param_neg = par[2];
  double decay_pos = par[3];
  double decay_neg = par[4];
  for(int i = 0; i < n; i++){
    r = reward[i];
    s = side[i];
    t = interval[i];
    vs = abs(s - 1);
    if (rev[s] > 0.5){
      decay = decay_pos;
    } else {
      decay = decay_neg;}
    q[s] = exp(0-(t * decay)) * q[s];
    if (rev[vs] > 0.5){
      decay = decay_pos;
    } else {
      decay = decay_neg;}
    q[vs] = exp(0-(t * decay)) * q[vs];
    pw = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    pw = std::min(pw, 0.999);
    pw = std::max(pw, 0.001);
  nll += -log(pw);
  rev[s] = r;
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
