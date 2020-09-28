# instance of changing criteria of correct prediction
sourceCpp("cpp/predict/predict_random.cpp")
which = "random"
temp = list(
  random = tibble(
    tag = unique(dmodel$tag),
    par.value = 1,
    name = "random"))

resultprediction[[which]] <- summary_predict(a_model = temp)