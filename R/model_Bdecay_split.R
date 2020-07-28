# beta-decay split --------------------------------------------------------
model <- function(par, a) {
  a = a[with(a, order(start)), ]
  nll = 0
  if (par[1] < 0 | par[1] > 1 |
      par[2] < 0 | par[2] > 50 |
      par[3] < 0 | par[3] > 1 |
      par[4] < 0 | par[4] > 1) {
    nll = Inf
  } else {
    Q = c(0, 0)
    date = a$start[1]
    t = 0
    P <- vector()
    rewards = a$dooropened
    sides = ceiling(a$corner/2)
    intervals = a$intervalb
    intervals[1] = 0
    beta.zero = par[2]
    rew = 0
    for (i in seq_along(sides)) {
      r = rewards[i]
      s = sides[i]
      t = intervals[i]
      t = ifelse(t > 660, 660, t)
      decay = ifelse(rew == 1, par[3], par[4])
      beta = exp( -t * decay ) * beta.zero
      P = exp(beta * Q) / sum(exp(beta * Q))
      if(P[s] < .001){P[s] = .001}
      if(P[s] > .999){P[s] = .999}
      nll = -log(P[s]) + nll
      pe = r - Q[s]
      Q[s] = Q[s] + (par[1] * pe)
      rew = r}}
  nll}

print("b-decay+")
remodel[["b-decay+"]] <-
  util_wrap("b-decay+", alpha = init$default,
            beta = init$beta,
            bdecay.pos = init$default,
            bdecay.neg = init$default)
saveRDS(remodel, 'result/remodel.rds')
