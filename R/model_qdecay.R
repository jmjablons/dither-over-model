# q-decay -----------------------------------------------------------------
model <- function(par, a) {
  a = a[with(a, order(start)), ]
  nll = 0
  if (par[1] < 0 | par[1] > 1 |
      par[2] < 0 | par[2] > 50 |
      par[3] < 0 | par[3] > 1) {
    nll = Inf
  } else {
    Q = c(0, 0)
    t = c(0, 0)
    P <- vector()
    rewards = a$dooropened
    sides = ceiling(a$corner/2)
    nows.start = a$start
    nows.end = a$end
    intervals = a$intervalb
    intervals[1] = 0
    for (i in seq_along(sides)) {
      r = rewards[i]
      s = sides[i]
      now.start = nows.start[i]
      now.end = nows.end[i]
      t = intervals[i]
      t = ifelse(t > 660, 660, t)
      Q = exp( -(t) * par[3] ) * Q
      P = exp(par[2] * Q) / sum(exp(par[2] * Q))
      if(P[s] < .001){P[s] = .001}
      if(P[s] > .999){P[s] = .999}
      nll = -log(P[s]) + nll
      pe = r - Q[s]
      Q[s] = Q[s] + (par[1] * pe)}}
  nll}

print("q-decay")
remodel[["q-decay"]] <- util_wrap("q-decay",
                                 alpha = init$default,
                                 beta = init$beta,
                                 storage = init$default)
saveRDS(remodel, 'result/remodel.rds')
