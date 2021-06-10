source("R/main/dependency.R")
source("R/util_eval/util_init_values.R")
source("R/util_eval/util_modelcpp_main.R")
source("R/util_eval/util_general.R")
source("R/util_eval/util_init_predict_newday.R")

rm(dmodel)
dmodel = readRDS("../skinner-ThpCreERT2-NR1/data/wsad_dmodel_modelcpp_skiner_20201116.rds")

source("R/util_eval/util_modelcpp_input_reward_side_session.R")

start <- Sys.time()
result_model <- list()
temp_predict_animalxmodel <- vector("list")


# basic -------------------------------------------------------------------
sourceCpp("./cpp/model/model_basic_newday.cpp")
temp_which = "basic"
result_model[[temp_which]] <- wrapmodel(alpha.pos = init$default, 
                                        beta = init$beta, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)
sourceCpp("cpp/predict/predict_basic_newday.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# dual --------------------------------------------------------------------
sourceCpp("./cpp/model/model_dual_newday.cpp")
temp_which = "dual"
result_model[[temp_which]] <- wrapmodel(alpha.pos = init$default, 
                                        beta = init$beta,
                                        alpha.neg = init$default,
                                        .input = dmodel) %>%  
  util_finish(temp_which)
sourceCpp("cpp/predict/predict_dual_newday.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# fictitious --------------------------------------------------------------
sourceCpp("./cpp/model/model_fictitious_newday.cpp")
temp_which = "fictitious"
result_model[[temp_which]] <- wrapmodel(alpha = init$default, 
                                        beta = init$beta,
                                        .input = dmodel) %>%  
  util_finish(temp_which)
sourceCpp("cpp/predict/predict_fictitious_newday.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# attention ---------------------------------------------------------------
sourceCpp("./cpp/model/model_attention_newday.cpp")
temp_which = "attention"
result_model[[temp_which]] <- wrapmodel(alpha0 = init$default, 
                                        beta = init$beta, 
                                        mi = init$default,
                                        .input = dmodel) %>%  
  util_finish(temp_which)
sourceCpp("cpp/predict/predict_attention_newday.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# incidental --------------------------------------------------------------
sourceCpp("./cpp/model/model_incidental_newday.cpp")
temp_which = "incidental"
result_model[[temp_which]] <- wrapmodel(alpha.real = init$default, 
                                        beta = init$beta, 
                                        alpha.fict = init$default, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)
sourceCpp("cpp/predict/predict_incidental_newday.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# hybrid ------------------------------------------------------------------
sourceCpp("./cpp/model/model_hybrid_newday.cpp")
temp_which = "hybrid"
result_model[[temp_which]] <- wrapmodel(alpha.pos = init$default, 
                                        beta = init$beta, 
                                        alpha.neg = init$default, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)
sourceCpp("cpp/predict/predict_hybrid_newday.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# imaginary ---------------------------------------------------------------
sourceCpp("./cpp/model/model_hybrid_imaginary_newday.cpp")
temp_which = "imaginary"
result_model[[temp_which]] <- wrapmodel(alpha.pos.real = init$default, 
                                        beta = init$beta, 
                                        alpha.neg.real = init$default, 
                                        alpha.pos.fict = init$default, 
                                        alpha.neg.fict = init$default, 
                                        .input = dmodel) %>%  
  util_finish(temp_which)
sourceCpp("cpp/predict/predict_hybrid_imaginary_newday.cpp")
temp_predict_animalxmodel[[temp_which]] <- summary_predict()

# noisy win-stay lose-shift -----------------------------------------------

sourceCpp("./cpp/model/model_noisywinstay.cpp")
temp_which = "noisywinstay"
temp <- dmodel %>%
  group_by(tag) %>%
  arrange(start, .by_group = T) %>%
  mutate(win = lag(dooropened),
         stay = ifelse(lag(side) == side, 1, 0)) %>%
  ungroup() %>%
  mutate(win = ifelse(is.na(win), 0, win),
         stay = ifelse(is.na(stay), 0, stay))

parsedata <- function(.tag, .input){
  temp <- .input[.input$tag == .tag,]
  temp = temp[with(temp, order(start)),]
  temp[c("side","win","stay","tag")]}

getoptimal_ <- function(dataset, list.parameters){ #one parameter
  out = c(tag = as.numeric(unique(dataset$tag)), 
          par = 0, value = Inf, maxPar = 0)
  for(i in list.parameters){
    value = modelC(par = i, side = dataset$side, win = dataset$win, stay = dataset$stay)
    out[4] = i
    if(value < out[3]){
      out[2] = i
      out[3] = value}}
  out}

result_model[[temp_which]] <- (function(initial, a = temp) {
  tags = unique(a$tag)
  output = list()
  for (m in tags) {
    dmouse = parsedata(m, temp)
    output[[m]] = getoptimal_(dmouse, initial)}
  do.call(rbind, output)})(seq(0.1, 1.999, 0.001)) %>% as_tibble() %>%
  mutate(name = temp_which, tag = as.character(tag), aic = getaic(1, value))

sourceCpp("cpp/predict/predict_noisywinstay.cpp")
source("R/util_eval/util_prepare_date_winstay.R")
temp_predict_animalxmodel[[temp_which]] <- summary_predict(run_predict_side_win_stay)


# finish ------------------------------------------------------------------

finish <- Sys.time()
print(difftime(finish,start))
saveRDS(result_model, paste0("result/result_model_skiner_thp2_",today(),".rds"))

temp_predict_animalxmodel %>%
  saveRDS(paste0("result/result_predict_animalxmodel_tph2_skinner_",today(),".rds"))
