temp <- remodel %>% 
  purrr::map(~select(., name, aic, tag)) %>%
  bind_rows() %>%
  group_by(tag) %>%
  dplyr::group_split(keep = TRUE) %>%
  purrr::map(~ mutate(., delta = .$aic - .$aic[.$name %in% "basic"]))%>%
  dplyr::bind_rows() %>%
  arrange(tag, name)

temp2 <- remodel %>% 
  purrr::map(~select(., name, aic, tag)) %>%
  dplyr::bind_rows() %>%
  dplyr::mutate(delta = aic - .$aic[.$tag == tag & .$name == "basic"]) %>%
  ungroup() %>%  
  arrange(tag, name)

all.equal(temp, temp2)