dmodel <- readRDS(file.choose())

dmodel = dmodel %>% 
  select(start, end, tag, dooropened, corner) %>%
  group_by(tag) %>%
  arrange(start, .by_group = TRUE) %>%
  mutate(interval = as.numeric(difftime(start - lag(end), units = 'mins'))) %>%
  ungroup() %>%
  mutate(
    corner = as.numeric(corner),
    dooropened = as.numeric(dooropened),
    side = ceiling(corner/2 - 1),
    corner = NULL,
    end = NULL,
    interval = ifelse(is.na(interval), 0, interval),
    interval = ifelse(interval > 660, 660, interval))
