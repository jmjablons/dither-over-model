#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double modelC(NumericVector par, NumericVector reward, NumericVector side, NumericVector interval){
  double q[2] = {0,0}, p[2] = {0, 0}, beta = par[1], pe, decay = par[2], t;
  short int n = side.size(), s, r, vs;
  double param_pos_real = par[0];
  double param_neg_real = par[2];
  double param_pos_fict = par[3];
  double param_neg_fict = par[4];
  for(int i = 0; i < n; i++){
    r = reward[i];
    s = side[i];
    vs = abs(s - 1);
    t = interval[i];
    q[s] = exp(0-(t * decay)) * q[s];
    q[vs] = exp(0-(t * decay)) * q[vs];
    p[s] = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    p[s] = std::min(p[s], 0.999);
    p[s] = std::max(p[s], 0.001);
    p[vs] = 1 - p[s];
    out[i] = p[0];
    if (r > 0.5) {
      pe = r - q[s];
      q[s] += (param_pos_real * pe);
      pe = (1-r) - q[vs];
      q[vs] += (param_neg_fict * pe);
    } else {
      pe = r - q[s];
      q[s] += (param_neg_real * pe);
      pe = (1-r) - q[vs];
      q[vs] += (param_pos_fict * pe);}}
return out;}
