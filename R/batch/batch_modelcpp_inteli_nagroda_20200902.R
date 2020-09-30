# model dane z publikacji
# dla porownania 
source("R/main/dependency.R")
source("R/util_eval/util_modelcpp_main.R")
source("R/util_eval/util_modelcpp_input_reward_side.R")

init <- list(default = c(0.05, 0.15, 0.35, 0.55, 0.75, 0.95),
             primitive = c(0.05, 0.15, 0.35, 0.55, 0.75, 0.95),
             totwo = c(0.05, 0.35, 0.75, 1, 1.25, 1.35, 2),
             beta = seq(0.25, 5, by = 1))

dmodel = dmodel %>%
  mutate(side = ceiling(corner/2 - 1))

start <- Sys.time()
result_model <- list()

sourceCpp("./cpp/model/model_basic.cpp")

result_model$basic <- wrapmodel(alpha.pos = init$default, beta = init$beta, .input = dmodel) %>%  
  util_finish("basic")

sourceCpp("./cpp/model/model_dual.cpp")

result_model$dual <- wrapmodel(alpha.pos = init$default, beta = init$beta, alpha.neg = init$default, .input = dmodel) %>%  
  util_finish("dual")

sourceCpp("./cpp/model/model_fictitious.cpp")

result_model$fictitious <- wrapmodel(alpha = init$default, beta = init$beta, .input = dmodel) %>%  
  util_finish("fictitious")

sourceCpp("./cpp/model/model_hybrid.cpp")

result_model$hybrid <- wrapmodel(alpha.pos = init$default, beta = init$beta, alpha.neg = init$default, .input = dmodel) %>%  
  util_finish("hybrid")

sourceCpp("./cpp/model/model_hybrid_original.cpp")

result_model$hybrid_original <- wrapmodel(alpha.pos = init$default, beta = init$beta, alpha.neg = init$default, .input = dmodel) %>%  
  util_finish("hybrid_original")

sourceCpp("./cpp/model/model_qdecay.cpp")

dmodel = dmodel %>%
  mutate(interval = ifelse(is.na(intervalb), 0, intervalb))

source("R/util_eval/util_modelcpp_input_reward_side_interval.R")

result_model$qdecay <- wrapmodel(alpha = init$default, beta = init$beta, storage = init$default, .input = dmodel) %>%  
  util_finish("q-decay")

finish <- Sys.time()

print(difftime(finish,start))
saveRDS(result_model, "result/result_model_inteli_reward_20200903.rds")