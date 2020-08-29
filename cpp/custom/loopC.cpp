#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector loopC(Function fun, NumericVector x){
  int n = x.size();
  NumericVector out(n);
  for(int i = 0; i < n; ++i){
    out[i] = fun(x[i]);
  }
  return out;
}
