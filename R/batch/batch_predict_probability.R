resultprediction %>%
  saveRDS("result/result_predict_inteli_black_20200925.rds")

prediction <- list()

sourceCpp("cpp/predict/predict_basic.cpp")
which = "basic"
prediction[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_fictitious.cpp")
which = "fictitious"
prediction[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_dual.cpp")
which = "dual"
prediction[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_hybrid_original.cpp")
which = "hybrid_original"
prediction[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_attention.cpp")
which = "attention"
prediction[[which]] <- run_predict_reward_side(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_bdecay.cpp")
which = "bdecay"
prediction[[which]] <- run_predict_reward_side_interval(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

sourceCpp("cpp/predict/predict_qdecay.cpp")
which = "qdecay"
prediction[[which]] <- run_predict_reward_side_interval(which) %>%
  select(start, tag, probchosen) %>%
  mutate(name = which)

prediction %>%
  saveRDS("result/result_predict_pwhole_inteli_black_20200928.rds")
