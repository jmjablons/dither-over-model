source("R/dependency.R")
source("R/util_modelcpp.R")

dmodel = readRDS("C:\\Users\\judyta\\Documents\\phDComputations\\inteli-ThpCreERT2-NR1\\wsad_dmodel.rds")

init <- list(default = c(0.05, 0.15, 0.35, 0.75, 0.95),
             primitive = c(0.05, 0.15, 0.35, 0.75, 0.95),
             totwo = c(0.05, 0.35, 0.75, 1, 1.25, 1.35, 2),
             beta = seq(0.25, 5, by = 1))
start <- Sys.time()
result_model <- list()

sourceCpp("./cpp/model_basic.cpp")

result_model$basic <- wrapmodel(alpha.pos = init$default, beta = init$beta, .input = dmodel) %>%  
  util_finish("basic")

sourceCpp("./cpp/model_dual.cpp")

result_model$dual <- wrapmodel(alpha.pos = init$default, beta = init$beta, alpha.neg = init$default, .input = dmodel) %>%  
  util_finish("dual")

sourceCpp("./cpp/model_fictitious.cpp")

result_model$fictitious <- wrapmodel(alpha = init$default, beta = init$beta, .input = dmodel) %>%  
  util_finish("fictitious")

sourceCpp("./cpp/model_hybrid.cpp")

result_model$hybrid <- wrapmodel(alpha.pos = init$default, beta = init$beta, alpha.neg = init$default, .input = dmodel) %>%  
  util_finish("hybrid")

sourceCpp("./cpp/model_qdecay.cpp")

dmodel = dmodel %>%
  mutate(interval = ifelse(is.na(intervalb), 0, intervalb))

parsedata <- function(.tag, .input){
  temp <- .input[.input$tag == .tag,]
  temp = temp[with(temp, order(start)),]
  temp[c("dooropened","side","interval")]}

getoptimal <- function(.param, .input, .fun) {
  nparam = length(.param)
  if(nparam > 2){max = c(1, 50, rep(1, (nparam - 2)))
  } else {max = c(1, 50)}
  temp <- apply(.param, 1, function(x){
    optim(par = x, fn = .fun, reward = .input$dooropened, side = .input$side, interval = .input$interval, 
          method="L-BFGS-B", lower = rep(0, nparam), upper = max)})
  unlist(temp[[which.min(lapply(temp,function(x) {unlist(x$value)}))]][-5])}

result_model$qdecay <- wrapmodel(alpha = init$default, beta = init$beta, storage = init$default, .input = dmodel) %>%  
  util_finish("q-decay")

finish <- Sys.time()

print(difftime(finish,start))