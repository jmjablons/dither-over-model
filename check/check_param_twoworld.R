sourceCpp("./cpp/model_hybrid.cpp")

temp <- wrapmodel(alpha.pos = init$default, beta = init$beta, alpha.neg = init$default, .input = dmodel) %>%  
  util_finish("basic")

check_diff <- function(param, name){
  temp %>%
    select(tag, modelC = {{param}}) %>%
    left_join(
      remodel$hybrid_correct %>%
        select(tag, modelR = {{param}})) %>%
    mutate(diff = modelC - modelR)}

check_diff(par.alpha.neg)
