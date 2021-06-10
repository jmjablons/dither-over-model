source("R/main/dependency.R")
source("R/util_eval/util_init_values.R")
source("R/util_eval/util_modelcpp_main.R")
source("R/util_eval/util_init_predict.R")
source("R/util_eval/util_general.R")
source("R/main/preprocess_input_data.R")

start <- Sys.time()
result_model <- list()
temp_predict_animalxmodel <- vector("list")

source("R/util_eval/util_modelcpp_input_reward_side.R")

# basic -------------------------------------------------------------------
sourceCpp("./cpp/model/model_basic.cpp")
temp_which = "basic"
result_model[[temp_which]] <- wrapmodel(alpha.pos = init$default, 
                                 beta = init$beta,
                                 .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_basic.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# dual --------------------------------------------------------------------
sourceCpp("./cpp/model/model_dual.cpp")
temp_which = "dual"
result_model[[temp_which]] <- wrapmodel(alpha.pos = init$default, 
                                        beta = init$beta,
                                        alpha.neg = init$default,
                                        .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_dual.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# fictitious --------------------------------------------------------------
sourceCpp("./cpp/model/model_fictitious.cpp")
temp_which = "fictitious"
result_model[[temp_which]] <- wrapmodel(alpha = init$default, 
                                        beta = init$beta,
                                        .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_fictitious.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# attention ---------------------------------------------------------------
sourceCpp("./cpp/model/model_attention.cpp")
temp_which = "attention"
result_model[[temp_which]] <- wrapmodel(alpha0 = init$default, 
                                        beta = init$beta, 
                                        mi = init$default,
                                        .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_attention.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# incidental --------------------------------------------------------------
sourceCpp("./cpp/model/model_incidental.cpp")
temp_which = "incidental"
result_model[[temp_which]] <- wrapmodel(alpha.real = init$default, 
                                        beta = init$beta, 
                                        alpha.fict = init$default, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_incidental.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# hybrid ------------------------------------------------------------------
sourceCpp("./cpp/model/model_hybrid.cpp")
temp_which = "hybrid"
result_model[[temp_which]] <- wrapmodel(alpha.pos = init$default, 
                                        beta = init$beta, 
                                        alpha.neg = init$default, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_hybrid.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# imaginary ---------------------------------------------------------------
sourceCpp("./cpp/model/model_hybrid_imaginary.cpp")
temp_which = "imaginary"
result_model[[temp_which]] <- wrapmodel(alpha.pos.real = init$default, 
                                        beta = init$beta, 
                                        alpha.neg.real = init$default, 
                                        alpha.pos.fict = init$default, 
                                        alpha.neg.fict = init$default, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_hybrid_imaginary.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# imaginary q-decay -------------------------------------------------------
source("R/util_eval/util_modelcpp_input_reward_side_interval.R")

sourceCpp("./cpp/model/model_imaginary_qdecay.cpp")
temp_which = "imaginaryqdecay"
result_model[[temp_which]] <- wrapmodel(alpha.pos.real = init$small, 
                                        beta = init$beta, 
                                        alpha.neg.real = init$small, 
                                        alpha.pos.fict = init$small, 
                                        alpha.neg.fict = init$small, 
                                        storage = init$small, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_imaginary_qdecay.cpp")
temp_predict_animalxmodel[[temp_which]] <- 
  summary_predict(run_predict_reward_side_interval)

# imaginary b-decay -------------------------------------------------------
sourceCpp("./cpp/model/model_imaginary_bdecay.cpp")
temp_which = "imaginarybdecay"
result_model[[temp_which]] <- wrapmodel(alpha.pos.real = init$small, 
                                        beta = init$beta, 
                                        alpha.neg.real = init$small, 
                                        alpha.pos.fict = init$small, 
                                        alpha.neg.fict = init$small, 
                                        decay = init$small, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)

sourceCpp("cpp/predict/predict_imaginary_bdecay.cpp")
temp_predict_animalxmodel[[temp_which]] <- 
  summary_predict(run_predict_reward_side_interval)

# noisy win-stay lose-shift -----------------------------------------------
sourceCpp("./cpp/model/model_noisywinstay.cpp")
source("R/util_eval/util_modelcpp_noisywinstay.R")
source("R/util_eval/util_prepare_date_winstay.R")

temp_which = "noisywinstay"

temp = prepare_data_winstay()

result_model[[temp_which]] <- run_noisywinstay(temp) %>%
  as_tibble() %>%
  mutate(name = temp_which, 
         tag = as.character(tag), 
         aic = getaic(1, value))

sourceCpp("cpp/predict/predict_noisywinstay.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict(run_predict_side_win_stay)

# the end -----------------------------------------------------------------
finish <- Sys.time()
print(difftime(finish,start))

saveRDS(result_model, paste0("result/result_model_inteli_general_",today(),".rds"))
saveRDS(temp_predict_animalxmodel, paste0("result/result_predict_inteli_general_",today(),".rds"))
