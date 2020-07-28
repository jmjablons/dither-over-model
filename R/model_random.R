# random ------------------------------------------------------------------
print("random")
remodel[["random"]] <- dmodel %>%
  group_by(tag) %>%
  summarise(n = length(corner)) %>%
  mutate(name = "random", aic = getaic(0, n * -log(0.5)))
saveRDS(remodel, 'result/remodel.rds')