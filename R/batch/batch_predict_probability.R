source("R/util_eval/util_init_predict.R")
temp_prediction_choicexmodel <- list()
#result_model = remodel

sourceCpp("cpp/predict/predict_basic.cpp")
which = "basic"
temp_prediction_choicexmodel[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_fictitious.cpp")
which = "fictitious"
temp_prediction_choicexmodel[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_dual.cpp")
which = "dual"
temp_prediction_choicexmodel[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

# sourceCpp("cpp/predict/predict_hybrid_original.cpp")
# which = "hybrid_original"
# temp_prediction_choicexmodel[[which]] <- run_predict_reward_side(which) %>%
#   select(start, tag, probchosen) %>%
#   mutate(name = which)

sourceCpp("cpp/predict/predict_hybrid_imaginary.cpp")
which = "hybrid_imaginary"
temp_prediction_choicexmodel[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_attention.cpp")
which = "attention"
temp_prediction_choicexmodel[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_bdecay.cpp")
which = "bdecay"
temp_prediction_choicexmodel[[which]] <- run_predict_reward_side_interval(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_qdecay.cpp")
which = "qdecay"
temp_prediction_choicexmodel[[which]] <- run_predict_reward_side_interval(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)
