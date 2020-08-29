getaic <- function(n.parameters, nll) {2 * nll + 2 * n.parameters}

util_finish <- function(.modelresult, .name){
  tibble::as_tibble(.modelresult) %>%
    dplyr::mutate(name = .name, 
                  tag = as.character(tag),
                  aic = (2 * length(which(grepl("par", names(.)))) + 
                           (2 * value)))}

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
