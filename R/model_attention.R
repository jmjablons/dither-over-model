# attention ---------------------------------------------------------------
model <- function(par, a) {
  a = a[with(a, order(start)), ]
  nll = 0
  if (par[1] < 0 | par[1] > 1 |
      par[2] < 0 | par[2] > 50 |
      par[3] < 0 | par[3] > 1) {
    nll = Inf
  } else {
    Q = c(0, 0)
    P <- vector()
    rewards = a$dooropened
    sides = ceiling(a$corner / 2)
    alpha.zero = par[1]
    for (i in seq_along(sides)) {
      r = rewards[i]
      s = sides[i]
      P = exp(par[2] * Q) / sum(exp(par[2] * Q))
      if(P[s] < .001){P[s] = .001}
      if(P[s] > .999){P[s] = .999}
      nll = -log(P[s]) + nll
      pe = r - Q[s]
      alpha = par[3] * abs(pe) + (1 - par[3]) * alpha.zero
      Q[s] = Q[s] + (alpha * pe)}}
  nll}

print("attention")
remodel[["attention"]] <-
  util_wrap("attention", alpha.zero = init$default,
            beta = init$beta, ni= init$default)
saveRDS(remodel, 'result/remodel.rds')