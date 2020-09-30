parsedata <- function(.tag, .input){
  temp <- .input[.input$tag == .tag,]
  temp = temp[with(temp, order(start)),]
  temp[c("side","win","stay","tag")]}

getoptimal_ <- function(a, list.parameters){
  out = c(tag = as.numeric(unique(a$tag)), 
          par = 0, value = Inf, maxPar = 0)
  for(i in list.parameters){
    value = modelC(par = i, 
                   side = a$side, 
                   win = a$win, 
                   stay = a$stay)
    out[4] = i
    if(value < out[3]){
      out[2] = i
      out[3] = value}}
  out}

run_noisywinstay <- function(a, initial = seq(0.1, 1.999, 0.001)){
  tags = unique(a$tag)
  output = list()
  for (m in tags) {
    dmouse = parsedata(m, temp)
    output[[m]] = getoptimal_(dmouse, initial)}
  do.call(rbind, output)}
