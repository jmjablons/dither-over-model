#sourceCpp("./cpp/loopC.cpp")
sourceCpp("./cpp/model_basic.cpp")
sourceCpp("./cpp/model_dual.cpp")

# any data passed to modelC are allowed to NA values,
# NA is subversed to double value!
any(is.na(dhero$corner))
any(is.na(dhero$dooropened))

bench::mark(
  model(temp_param, dhero),
  modelC(temp_param, reward = dhero$dooropened, 
         side = (ceiling(dhero$corner/2)-1))) %>% View()

bench::mark(
  util_wrap("basic", alpha = init$default, beta = init$beta),
  util_wrap2("basic", alpha = init$default, beta = init$beta)) %>% 
  View()

all.equal(temp %>% arrange(tag),
          remodel$basic %>% arrange(tag))

wrapmodel(alpha = init$default, beta = init$beta, .input = dx) %>%
  util_finish("basic")

wrapmodel(alpha.pos = init$default, beta = init$beta, alpha.neg = init$default, .input = dx) %>%
  util_finish("dual")
