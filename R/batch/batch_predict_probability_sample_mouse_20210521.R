source("R/main/dependency.R")
source("R/main/variable.R")
source("R/util_eval/util_init_values.R")
source("R/util_eval/util_modelcpp_main.R")
source("R/util_eval/util_modelcpp_input_reward_side.R")
rm(dmodel)
source("R/main/preprocess_input_data.R")

result_model <- list()
sourceCpp("./cpp/model/model_basic.cpp")
result_model$basic <- wrapmodel(alpha = init$default, 
                                     beta = init$beta,
                                     .input = dmodel) %>%  
  util_finish("basic")

temp_mouse <- "900110000324287"

source("R/util_eval/util_init_predict.R")
temp_predict_animalxmodel <- vector("list")

sourceCpp("cpp/predict/predict_basic.cpp")
which = "basic"

temp <- run_predict_reward_side("basic", a = (dmodel %>% filter(tag %in% temp_mouse)))

saveRDS(temp, paste0("result/result_predict_sample_mouse_",Sys.Date(),".rds"))

result_model$basic %>%
  filter(tag %in% temp_mouse)
