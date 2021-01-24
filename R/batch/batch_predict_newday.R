source("R/util_eval/util_init_predict_newday.R")

temp_predict_animalxmodel <- vector("list")

sourceCpp("cpp/predict/predict_basic_newday.cpp")
which = "basic"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_fictitious_newday.cpp")
which = "fictitious"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_dual_newday.cpp")
which = "dual"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_hybrid_imaginary_newday.cpp")
which = "hybrid_imaginary"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_attention_newday.cpp")
which = "attention"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_noisywinstay.cpp")
source("R/util_eval/util_prepare_date_winstay.R")
which = "noisywinstay"
temp_predict_animalxmodel[[which]] <- summary_predict(run_predict_side_win_stay)

temp_predict_animalxmodel %>%
  saveRDS(paste0("result/result_predict_animalxmodel_tph2_skinner_",lubridate::today(),".rds"))
