#setwd('~/phDCompute/inteli-ThpCreERT2-NR1/model_source/')

# dependency --------------------------------------------------------------
library(dplyr)

# prepare data ------------------------------------------------------------
# temp <- dmodel %>% filter(cohort %in% c(1,3)) %>% arrange(start)
# saveRDS(temp, 
# file = '~/phDCompute/inteli-ThpCreERT2-NR1/model_source/data/dmodel_tph2.rds')

# custom ------------------------------------------------------------------
getaic <- function(n.parameters, nll) {2 * nll + 2 * n.parameters}

getoptimal_ <- function(dataset, list.parameters){ #one parameter
  out = c(tag = as.numeric(unique(dataset$tag)), 
          par = 0, value = Inf, maxPar = 0)
  for(i in list.parameters){
    value = model(i, dataset)
    out[4] = i
    if(value < out[3]){
      out[2] = i
      out[3] = value}}
  out}

getoptimal <- function(input.data, list.parameters) {
  optim.results <- list()
  sample.size = nrow(list.parameters)
  val = Inf
  mouse = as.numeric(unique(input.data$tag))
  temp <- apply(list.parameters, 1, function(x){
    optim(par = x, fn = model, a = input.data)})
  best.optim <- temp[[which.min(lapply(temp,function(x) {unlist(x$value)}))]]
  c(tag = mouse, unlist(best.optim))}

wrapmodel <- function(list.parameters, a = dmodel, tags = NULL) {
  if(is.null(tags)){tags = as.character(unique(a$tag))}
  progressbar <- txtProgressBar(0, length(tags), char = '*', style = 3)
  output = list()
  for(m in seq_along(tags)) {
    dmouse = a[a$tag == tags[m], ]
    output[[m]] = getoptimal(dmouse, list.parameters)
    setTxtProgressBar(progressbar, m)}
  close(progressbar)
  do.call(rbind, output)}

util_wrap <- function(name, ...){
  initial <- expand.grid(...)
  #initial = as.list(initial)
  wrapmodel(initial) %>% as_tibble() %>%
    mutate(name = name, tag = as.character(tag),
           aic = getaic(length(initial), value))}

# variables ---------------------------------------------------------------
init <- list(default = c(0.05, 0.15, 0.35, 0.55, 0.75, 0.95),
             primitive = c(0.05, 0.15, 0.35, 0.55, 0.75, 0.95),
             totwo = c(0.05, 0.35, 0.75, 1, 1.25, 1.35, 2),
             beta = seq(0.25, 5, by = 1))

#remodel <- list()

# read dataset ------------------------------------------------------------
#rm(dmodel)
#dmodel <- readRDS('data/dmodel_tph2.rds')