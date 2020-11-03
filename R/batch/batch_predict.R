source("R/util_eval/util_init_predict.R")

temp_predict_animalxmodel <- vector("list")

sourceCpp("cpp/predict/predict_basic.cpp")
which = "basic"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_fictitious.cpp")
which = "fictitious"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_dual.cpp")
which = "dual"
temp_predict_animalxmodel[[which]] <- summary_predict()

# sourceCpp("cpp/predict/predict_hybrid_original.cpp")
# which = "hybrid_original"
# temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_hybrid_imaginary.cpp")
which = "hybrid_imaginary"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_attention.cpp")
which = "attention"
temp_predict_animalxmodel[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_bdecay.cpp")
which = "bdecay"
temp_predict_animalxmodel[[which]] <- summary_predict(run_predict_reward_side_interval)

sourceCpp("cpp/predict/predict_qdecay.cpp")
which = "qdecay"
temp_predict_animalxmodel[[which]] <- summary_predict(run_predict_reward_side_interval)

sourceCpp("cpp/predict/predict_noisywinstay.cpp")
which = "noisywinstay"
temp_predict_animalxmodel[[which]] <- summary_predict(run_predict_side_win_stay)
