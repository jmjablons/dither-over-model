# relational --------------------------------------------------------------
# JR: time
model <- function(par, a) {
  a = a[with(a, order(start)), ]
  nll = 0
  if (par[1] < 0 | par[1] > 1 |
      par[2] < 0 | par[2] > 50 |
      par[3] < 0 | par[3] > 1 |
      par[4] < 0 | par[4] > 7) {
    nll = Inf
  } else {
    Q = c(0, 0)
    P <- vector()
    b0 = 0
    rewards = a$dooropened
    sides = ceiling(a$corner / 2)
    previous = lag(sides)
    previous[1] = 1
    intervals = a$intervalb
    intervals[1] = 0
    for (i in seq_along(sides)) {
      r = rewards[i]
      s = sides[i]
      w = previous[i]
      t = intervals[i]
      P = exp(par[2] * Q) / sum(exp(par[2] * Q))
      P = ifelse(P < .001, .001, P)
      P = ifelse(P > .999, .999, P)
      b0 = log(P[w] / (1 - P[w]))
      if(t > 660) t = 660
      P[w] = exp(b0 + par[3] * t - par[4]) /
        (1 + exp(b0 + par[3] * t - par[4]))
      P[-w] = 1 - P[w]
      if(P[s] < .001){P[s] = .001}
      if(P[s] > .999){P[s] = .999}
      nll = -log(P[s]) + nll
      pe = r - Q[s]
      Q[s] = Q[s] + (par[1] * pe)}}
  nll}

remodel[["relational"]] <-
  util_wrap("relational", alpha = init$default, beta = init$beta,
            iota = init$primitive, rho = init$default)
