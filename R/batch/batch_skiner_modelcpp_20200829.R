source("R/main/dependency.R")
source("R/util_eval/util_variable.R")
source("R/util_eval/util_modelcpp_main.R")

dmodel = readRDS(file.choose())
start <- Sys.time()
result_model <- list()

# run ---------------------------------------------------------------------
source("R/util_eval/util_modelcpp_input_reward_side.R")
sourceCpp("cpp/model/model_basic.cpp")

result_model$basic <- wrapmodel(alpha = init$default, 
                                beta = init$beta, 
                                .input = dmodel) %>% util_finish("basic")

sourceCpp("cpp/model/model_dual.cpp")

result_model$dual <- wrapmodel(alpha.pos = init$default, 
                                beta = init$beta, 
                                alpha.neg = init$default,
                                .input = dmodel) %>% util_finish("dual")

sourceCpp("cpp/model/model_fictitious.cpp")

result_model$fictitious <- wrapmodel(alpha = init$default, 
                               beta = init$beta, 
                               .input = dmodel) %>% util_finish("fictitious")

sourceCpp("cpp/model/model_hybrid.cpp")

result_model$hybrid <- wrapmodel(alpha.pos = init$default, 
                                     beta = init$beta, 
                                     alpha.neg = init$default,
                                     .input = dmodel) %>% util_finish("hybrid")

sourceCpp("cpp/model/model_attention.cpp")

result_model$attention <- wrapmodel(alpha.pos = init$default, 
                                 beta = init$beta, 
                                 alpha.neg = init$default,
                                 .input = dmodel) %>% util_finish("attention")

# new day -----------------------------------------------------------------
source("R/util_eval/util_modelcpp_input_reward_side_session.R")
sourceCpp("cpp/model/model_basic_newday.cpp")

result_model$basicnew <- wrapmodel(alpha = init$default, 
                                beta = init$beta, 
                                .input = dmodel) %>% util_finish("basicnew")

sourceCpp("cpp/model/model_dual_newday.cpp")

result_model$dualnew <- wrapmodel(alpha.pos = init$default, 
                               beta = init$beta, 
                               alpha.neg = init$default,
                               .input = dmodel) %>% util_finish("dualnew")

sourceCpp("cpp/model/model_fictitious_newday.cpp")

result_model$fictitiousnew <- wrapmodel(alpha = init$default, 
                                     beta = init$beta, 
                                     .input = dmodel) %>% util_finish("fictitiousnew")

sourceCpp("cpp/model/model_hybrid_newday.cpp")

result_model$hybridnew <- wrapmodel(alpha.pos = init$default, 
                                 beta = init$beta, 
                                 alpha.neg = init$default,
                                 .input = dmodel) %>% util_finish("hybridnew")

sourceCpp("cpp/model/model_attention_newday.cpp")

result_model$attentionnew <- wrapmodel(alpha.pos = init$default, 
                                    beta = init$beta, 
                                    alpha.neg = init$default,
                                    .input = dmodel) %>% util_finish("attentionnew")

# save --------------------------------------------------------------------
finish <- Sys.time()
howlong = difftime(finish, start)
saveRDS(result_model, "./result/result_model20200829.rds")

