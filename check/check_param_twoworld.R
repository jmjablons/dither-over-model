sourceCpp("./cpp/model_hybrid.cpp")

temp <- wrapmodel(alpha.pos = init$default, beta = init$beta, alpha.neg = init$default, .input = dmodel) %>%  
  util_finish("basic")

check_diff <- function(param, name){
  temp %>%
    select(tag, modelC = {{param}}) %>%
    left_join(
      remodel$hybrid_correct %>%
        select(tag, modelR = {{param}})) %>%
    mutate(diff = modelC - modelR)}

check_diff(par.alpha.neg)

dmodel$intervalb[is.na(dmodel$intervalb)] = 0
dmodel$intervalb[dmodel$intervalb > 600] = 600
sourceCpp("./cpp/model_qdecay.cpp")

getoptimal <- function(.param, .input, .fun) {
  nparam = length(.param)
  if(nparam > 2){max = c(1, 50, rep(1, (nparam - 2)))
  } else {max = c(1, 50)}
  temp <- apply(.param, 1, function(x){
    optim(par = x, fn = .fun, reward = .input$dooropened, 
          side = .input$side,
          interval = .input$intervalb,
          method="L-BFGS-B", lower = rep(0, nparam), upper = max)})
  unlist(temp[[which.min(lapply(temp,function(x) {unlist(x$value)}))]][-5])}

parsedata <- function(.tag, .input){
  temp <- .input[.input$tag == .tag,]
  temp = temp[with(temp, order(start)),]
  temp[c("dooropened","side","intervalb")]}

wrapmodel <- function(..., .input = dmodel, .fun = modelC) {
  initial <- expand.grid(...)
  tags <- unique(.input$tag)
  progressbar <- txtProgressBar(0, length(tags), char = '$', style = 3)
  output = vector("list", length = length(tags))
  for(m in seq_along(tags)) {
    mouse = tags[m]
    dmouse <- parsedata(mouse, .input)
    output[[m]] = c(getoptimal(initial, dmouse, .fun), 
                    tag = as.numeric(mouse))
    setTxtProgressBar(progressbar, m)}
  close(progressbar)
  do.call(rbind, output)}
Sys.time()
temp <- wrapmodel(
  alpha = init$default, 
  beta = init$beta, 
  storage = init$default,
  .input = dmodel)
Sys.time()
