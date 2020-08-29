cppFunction('double modelC(NumericVector par, NumericVector reward, NumericVector side){
double q[2] = {0,0}, pw, nll, beta, pe;
short int n = side.size(), s;
beta = par[1];
for(int i = 0; i <= n; i++){
  s = side[i];
  pw = (exp(beta * q[s])) / (exp(beta * q[0]) + exp(beta * q[1]));
  if(pw < 0.001){
    pw = 0.001;
    }
  if(pw > 0.999){
    pw = 0.999;
    }
  nll += -log(pw); 
  pe = reward[i] - q[s];
  q[s] += (par[0] * pe);
    }
return nll;
  }')

model <- function(par, a) {
  #a = a[with(a, order(start)), ]
  nll = 0
    Q = c(0, 0)
    P <- vector()
    rewards = a$dooropened
    sides = ceiling(a$corner / 2)
    for (i in seq_along(sides)) {
      r = rewards[i]
      s = sides[i]
      P = exp(par[2] * Q) / sum(exp(par[2] * Q))
      if(P[s] < .001){P[s] = .001}
      if(P[s] > .999){P[s] = .999}
      nll = -log(P[s]) + nll
      pe = r - Q[s]
      Q[s] = Q[s] + (par[1] * pe)}
  nll}

modelC(par = c(0.01, 5), 
       reward = dhero$dooropened, 
       side = (ceiling(dhero$corner/2)-1))

temp <- bench::mark(
  model(par = c(0.0001, .5), a = dhero))

temp2 <- bench::mark(
  modelC(par = c(0.1, .5), 
         reward = dhero$dooropened, 
         side = (ceiling(dhero$corner/2)-1)))