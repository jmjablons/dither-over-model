source("R/main/dependency.R")
source("R/main/variable.R")
source("R/util_eval/util_init_values.R")
source("R/util_eval/util_modelcpp_main.R")
source("R/util_eval/util_modelcpp_input_reward_side_session.R")
dmodel = readRDS("../skinner-ThpCreERT2-NR1/data/wsad_dmodel_modelcpp_skiner_20200903.rds")
start <- Sys.time()
result_model <- list()

sourceCpp("./cpp/model/model_basic_newday.cpp")
result_model$basic <- wrapmodel(alpha.pos = init$default, 
                                beta = init$beta, 
                                .input = dmodel) %>%  
  util_finish("basic")

sourceCpp("./cpp/model/model_attention_newday.cpp")
result_model$attention <- wrapmodel(
  alpha.zero = init$default, 
  beta = init$beta, 
  mi = init$default, 
  .input = dmodel) %>%  
  util_finish("attention")

sourceCpp("./cpp/model/model_dual_newday.cpp")
result_model$dual <- wrapmodel(alpha.pos = init$default, 
                               beta = init$beta, 
                               alpha.neg = init$default, 
                               .input = dmodel) %>%  
  util_finish("dual")

sourceCpp("./cpp/model/model_fictitious_newday.cpp")
result_model$fictitious <- wrapmodel(alpha = init$default, 
                                     beta = init$beta, 
                                     .input = dmodel) %>%  
  util_finish("fictitious")

sourceCpp("./cpp/model/model_hybrid_original_newday.cpp")
result_model$hybrid_original <- wrapmodel(alpha.pos = init$default, 
                                 beta = init$beta, 
                                 alpha.neg = init$default, 
                                 .input = dmodel) %>%  
  util_finish("hybrid_original")

sourceCpp("./cpp/model/model_hybrid_imaginary_newday.cpp")

result_model$hybrid_imaginary <- wrapmodel(
  alpha.pos.real = init$default, 
  beta = init$beta, 
  alpha.neg.real = init$default, 
  alpha.pos.fict = init$default, 
  alpha.neg.fict = init$default, 
  .input = dmodel) %>%  
  util_finish("hybrid_imaginary")

finish <- Sys.time()
print(difftime(finish,start))
saveRDS(result_model, "result/result_model_skiner_thp2_20200903.rds")
