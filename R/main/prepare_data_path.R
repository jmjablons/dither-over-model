prepare_data_path <- function(a){readRDS(a) %>%
  mutate(visitduration = difftime(end, start, units = "secs")) %>%
  filter(info %in% 'reversal', rp > 0, visitduration > 2) %>%
  group_by(tag) %>%
  arrange(tag, start, .by_group = T) %>%
  mutate(
    id = row_number(),
    interval = difftime(start, lag(end), units = "mins")) %>%
  ungroup() %>%
  mutate(
    side = ceiling(as.numeric(corner)/2 - 1),
    corner = NULL,
    dooropened = as.numeric(dooropened),
    interval = ifelse(is.na(interval), 0, interval),
    interval = ifelse(interval > 660, 660, interval)) %>%
  select(start = id, side, dooropened, interval, tag) %>%
  arrange(tag, start)}
