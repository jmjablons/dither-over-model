parsedata <- function(.tag, .input){
  temp <- .input[.input$tag == .tag,]
  temp = temp[with(temp, order(start)),]
  temp[c("dooropened","side")]}

getoptimal <- function(.param, .input, .fun) {
  nparam = length(.param)
  if(nparam > 2){max = c(1, 50, rep(1, (nparam - 2)))}
  temp <- apply(.param, 1, function(x){
    optim(par = x, fn = .fun, reward = .input$dooropened, side = .input$side, 
          method="L-BFGS-B", lower = rep(0, nparam), upper = max)})
  unlist(temp[[which.min(lapply(temp,function(x) {unlist(x$value)}))]][-5])}

wrapmodel <- function(..., .input = dmodel, .fun = modelC) {
  initial <- expand.grid(...)
  tags <- unique(.input$tag)
  progressbar <- txtProgressBar(0, length(tags), char = '$', style = 3)
  output = vector("list", length = length(tags))
  for(m in seq_along(tags)) {
    mouse = tags[m]
    dmouse <- parsedata(mouse, .input)
    output[[m]] = c(getoptimal(initial, dmouse, .fun), 
                    tag = as.numeric(mouse))
    setTxtProgressBar(progressbar, m)}
  close(progressbar)
  do.call(rbind, output)}

util_finish <- function(.modelresult, .name){
  tibble::as_tibble(.modelresult) %>%
    dplyr::mutate(name = .name, 
                  tag = as.character(tag),
                  aic = (2 * length(which(grepl("par", names(.)))) + 
                           (2 * value)))}
