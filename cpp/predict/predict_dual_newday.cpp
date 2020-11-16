#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector predictC(NumericVector par, NumericVector reward, NumericVector side, NumericVector session){
  double q[2] = {0,0}, p[2] = {0, 0}, beta = par[1], pe, param;
  short int n = side.size(), s, vs, r, now, day = session[0];
  NumericVector out(n);
  for(int i = 0; i < n; i++){
    now = session[i];
    s = side[i];
    vs = abs(s - 1);
    r = reward[i];
    if (now > day) {
    q[0] = q[1] = 0;
    day = session[i];}
    p[s] = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
    p[s] = std::min(p[s], 0.999);
    p[s] = std::max(p[s], 0.001);
    p[vs] = 1 - p[s];
    out[i] = p[0];
  pe = reward[i] - q[s];
  if (r > 0.5) {
      param = par[0];
    } else {
      param = par[2];}
    q[s] += (param * pe);}
return out;}
