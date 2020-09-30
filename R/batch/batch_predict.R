source("R/util_eval/util_init_predict.R")

resultprediction <- vector("list")

sourceCpp("cpp/predict/predict_basic.cpp")
which = "basic"
resultprediction[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_fictitious.cpp")
which = "fictitious"
resultprediction[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_dual.cpp")
which = "dual"
resultprediction[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_hybrid_original.cpp")
which = "hybrid_original"
resultprediction[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_attention.cpp")
which = "attention"
resultprediction[[which]] <- summary_predict()

sourceCpp("cpp/predict/predict_bdecay.cpp")
which = "bdecay"
resultprediction[[which]] <- summary_predict(run_predict_reward_side_interval)

sourceCpp("cpp/predict/predict_qdecay.cpp")
which = "qdecay"
resultprediction[[which]] <- summary_predict(run_predict_reward_side_interval)

sourceCpp("cpp/predict/predict_noisywinstay.cpp")
