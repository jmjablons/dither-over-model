sourceCpp("./cpp/model/model_noisywinstay.cpp")
dmodel = readRDS("../skinner-ThpCreERT2-NR1/data/wsad_dmodel_modelcpp_skiner_20200903.rds")

temp <- dmodel %>%
  mutate(win = lag(dooropened),
         stay = ifelse(lag(side) == side, 1, 0)) %>%
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

remodel[["noisywinstay"]] <- (function(initial, a = temp) {
    tags = unique(a$tag)
    output = list()
    for (m in tags) {
      dmouse = parsedata(m, temp)
      output[[m]] = getoptimal_(dmouse, initial)}
    do.call(rbind, output)})(seq(0.1, 1.999, 0.001)) %>% as_tibble() %>%
  mutate(name = "noisywinstay", tag = as.character(tag), aic = getaic(1, value))

saveRDS(remodel[["noisywinstay"]], "result/result_model_skiner_tph2_noisywinstay_20200916.rds")
