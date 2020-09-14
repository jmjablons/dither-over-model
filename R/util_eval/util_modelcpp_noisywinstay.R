sourceCpp("./cpp/model/model_noisywinstay.cpp")

temp <- dmodel %>%
  mutate(win = lag(dooropened),
         stay = ifelse(lag(side) == side, 1, 0)) %>%
  mutate(win = ifelse(is.na(win), 0, win),
         stay = ifelse(is.na(stay), 0, stay))

