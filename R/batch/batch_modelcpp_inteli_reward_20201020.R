source("R/main/dependency.R")
source("R/main/variable.R")
source("R/util_eval/util_init_values.R")
source("R/util_eval/util_modelcpp_main.R")
source("R/util_eval/util_modelcpp_input_reward_side.R")

dmodel = readRDS("../inteli-reward/data/wsad_dmodel_ditherovermodel_20201020.rds")

start <- Sys.time()
result_model <- list()

sourceCpp("./cpp/model/model_basic.cpp")
result_model$basic <- wrapmodel(alpha.pos = init$default, 
                                beta = init$beta, 
                                .input = dmodel) %>%  
  util_finish("basic")

sourceCpp("./cpp/model/model_dual.cpp")
result_model$dual <- wrapmodel(alpha.pos = init$default, 
                               beta = init$beta, 
                               alpha.neg = init$default, 
                               .input = dmodel) %>%  
  util_finish("dual")

sourceCpp("./cpp/model/model_fictitious.cpp")
result_model$fictitious <- wrapmodel(alpha = init$default, 
                                     beta = init$beta, 
                                     .input = dmodel) %>%  
  util_finish("fictitious")

# sourceCpp("./cpp/model/model_hybrid.cpp")
# result_model$hybrid <- wrapmodel(alpha.pos = init$default, 
#                                  beta = init$beta, 
#                                  alpha.neg = init$default, 
#                                  .input = dmodel) %>%  
#   util_finish("hybrid")

sourceCpp("./cpp/model/model_attention.cpp")
result_model$attention <- wrapmodel(alpha0 = init$default, 
                                    beta = init$beta, 
                                    mi = init$default,
                                    .input = dmodel) %>%  
  util_finish("attention")

sourceCpp("./cpp/model/model_hybrid_original.cpp")
result_model$hybrid_original <- wrapmodel(alpha.pos = init$default, 
                                          beta = init$beta, 
                                          alpha.neg = init$default, 
                                          .input = dmodel) %>%  
  util_finish("hybrid_original")

saveRDS(result_model, "result/result_model_inteli_reward_20201020.rds")

sourceCpp("./cpp/model/model_hybrid_imaginary.cpp")
result_model$hybrid_imaginary <- wrapmodel(
  alpha.pos.real = init$default, 
  beta = init$beta, 
  alpha.neg.real = init$default, 
  alpha.pos.fict = init$default, 
  alpha.neg.fict = init$default, 
  .input = dmodel) %>%  
  util_finish("hybrid_imaginary")

source("R/util_eval/util_modelcpp_input_reward_side_interval.R")

sourceCpp("./cpp/model/model_qdecay.cpp")
result_model$qdecay <- wrapmodel(alpha = init$default, 
                                 beta = init$beta, 
                                 storage = init$default, 
                                 .input = dmodel) %>%  
  util_finish("q-decay")

sourceCpp("./cpp/model/model_bdecay.cpp")
result_model$bdecay <- wrapmodel(alpha = init$default, 
                                 beta.zero = init$beta, 
                                 decay = init$default, 
                                 .input = dmodel) %>%  
  util_finish("b-decay")

sourceCpp("./cpp/model/model_noisywinstay.cpp")
source("R/util_eval/util_modelcpp_noisywinstay.R")
source("R/util_eval/util_prepare_date_winstay.R")

temp = prepare_data_winstay()
result_model$noisywinstay <- run_noisywinstay(temp) %>%
  as_tibble() %>%
  mutate(name = "noisywinstay", 
         tag = as.character(tag), 
         aic = getaic(1, value))

finish <- Sys.time()
print(difftime(finish,start))
saveRDS(result_model, "result/result_model_inteli_reward_20201020.rds")
