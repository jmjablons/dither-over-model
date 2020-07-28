# hybrid ------------------------------------------------------------------
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
    for (i in seq_along(sides)) {
      r = rewards[i]
      s = sides[i]
      P = exp(par[2] * Q) / sum(exp(par[2] * Q))
      if(P[s] < .001){P[s] = .001}
      if(P[s] > .999){P[s] = .999}
      nll = -log(P[s]) + nll
      pe = r - Q[s]
      pe2 = (1-r) - Q[-s]
      if (r == 1) {
        Q[s] = Q[s] + (par[1] * pe)
        Q[-s] = Q[-s] + (par[1] * pe2)
      } else {
        Q[s] = Q[s] + (par[3] * pe)
        Q[-s] = Q[-s] + (par[3] * pe2)}}}
  nll}

print("hybrid_correct")
remodel[["hybrid_correct"]] <- util_wrap("hybrid_correct",alpha.pos = init$default,
                                 beta =  init$beta,
                                 alpha.neg = init$default)
saveRDS(remodel, 'result/remodel.rds')
