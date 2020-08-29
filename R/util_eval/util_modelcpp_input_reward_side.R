parsedata <- function(.tag, .input){
  temp <- .input[.input$tag == .tag,]
  temp = temp[with(temp, order(start)),]
  temp[c("dooropened","side")]}

getoptimal <- function(.param, .input, .fun) {
  nparam = length(.param)
  if(nparam > 2){max = c(1, 50, rep(1, (nparam - 2)))
  } else {max = c(1, 50)}
  temp <- apply(.param, 1, function(x){
    optim(par = x, fn = .fun, 
          reward = .input$dooropened, 
          side = .input$side, 
          method="L-BFGS-B", lower = rep(0, nparam), upper = max)})
  unlist(temp[[which.min(lapply(temp,function(x) {unlist(x$value)}))]][-5])}
