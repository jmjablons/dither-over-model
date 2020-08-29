# noisy win-stay ----------------------------------------------------------
model <-
  function(par, a) {
    a = a[with(a, order(start)), ]
    nll = 0
    if (par[1] < 0.001 | par[1] > 1.999) {
      nll = Inf
    } else {
      P <- vector()
      rewards = a$dooropened
      sides = ceiling(a$corner/2)
      previous.rewards = lag(rewards)
      previous.sides = lag(sides)
      for (i in seq_along(sides)) {
        r = previous.rewards[i]
        c = previous.sides[i]
        k = sides[i]
        stay = c == k
        win = r == 1
        if(i == 1){ P[k] = .5
        } else {
          if((win & stay) | (!win & !stay)){
            P[k] = 1 - par[1]/2
            if(P[k] < .001){P[k] = .001}
            if(P[k] > .999){P[k] = .999}}
          if((win & !stay)| (!win & stay)){
            P[k] = 0 + par[1]/2
            if(P[k] < .001){P[k] = .001}
            if(P[k] > .999){P[k] = .999}}}
        nll = -log(P[k]) + nll}}
    nll}

print("noisywinstay")
remodel[["noisywinstay"]] <-
  (function(initials, a = dmodel) {
    tags = as.character(levels(as.factor(a$tag)))
    output = list()
    for (m in seq_along(tags)) {
      dmouse = a[a$tag == tags[m], ]
      output[[m]] = getoptimal_(dmouse, initials)}
    do.call(rbind, output)})(seq(0.001, 1.999, 0.001)) %>% as_tibble() %>%
  mutate(name = "noisywinstay", tag = as.character(tag), aic = getaic(1, value))

saveRDS(remodel, 'result/remodel.rds')
