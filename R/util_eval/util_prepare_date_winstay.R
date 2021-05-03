prepare_data_winstay <- function(a = dmodel){
  a %>% group_by(tag) %>%
    arrange(start, .by_group = T) %>%
    mutate(win = lag(dooropened),
           stay = ifelse(lag(side) == side, 1, 0)) %>%
    ungroup() %>%
    mutate(win = ifelse(is.na(win), 0, win),
           stay = ifelse(is.na(stay), 0, stay))}
