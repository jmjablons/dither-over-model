run_predict_reward_side <- function(name, a = dmodel, a_model = result_model){
  mice = unique(a$tag)
  out <- vector("list", length(mice))
  for(i in seq_along(mice)){
    mouse = mice[i]
    mouse_par = a_model[[name]] %>%
      filter(tag %in% mouse) %>%
      select(grep(pattern = "par.*", names(.))) %>%
      unlist()
    dmouse = a %>%
      filter(tag %in% mouse) %>%
      arrange(start)
    dmouse$prob0 = predictC(mouse_par, dmouse$dooropened, dmouse$side)
    out[[i]] <- (dmouse %>% mutate(probchosen = ifelse(side %in% 0, prob0, 1-prob0)))}
  return(dplyr::bind_rows(out))}

run_predict_reward_side_interval <- function(name, a = dmodel, a_model = result_model){
  mice = unique(a$tag)
  out <- vector("list", length(mice))
  for(i in seq_along(mice)){
    mouse = mice[i]
    mouse_par = a_model[[name]] %>%
      filter(tag %in% mouse) %>%
      select(grep(pattern = "par.*", names(.))) %>%
      unlist()
    dmouse = a %>%
      filter(tag %in% mouse) %>%
      arrange(start)
    dmouse$prob0 = predictC(mouse_par, dmouse$dooropened, dmouse$side, dmouse$interval)
    out[[i]] <- (dmouse %>% mutate(probchosen = ifelse(side %in% 0, prob0, 1-prob0)))}
  return(dplyr::bind_rows(out))}

run_predict_side_win_stay <- function(name, a = dmodel, a_model = result_model){
  mice = unique(a$tag)
  out <- vector("list", length(mice))
  for(i in seq_along(mice)){
    mouse = mice[i]
    mouse_par = a_model[[name]] %>%
      filter(tag %in% mouse) %>%
      select(grep(pattern = "par.*", names(.))) %>%
      unlist()
    dmouse = a %>%
      filter(tag %in% mouse) %>%
      arrange(start) %>%
      prepare_data_winstay()
    dmouse$prob0 = predictC(mouse_par, dmouse$side, dmouse$win, dmouse$stay)
    out[[i]] <- (dmouse %>% mutate(probchosen = ifelse(side %in% 0, prob0, 1-prob0)))}
  return(dplyr::bind_rows(out))}

summary_predict <- function(.fun = run_predict_reward_side, .which = which, ...){
  .fun(which, ...) %>%
    group_by(tag) %>%
    summarise(correctprediction = length(which(probchosen > 0.5))/n()) %>%
    mutate(name = which)}
