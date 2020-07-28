devtools::install_github("jmjablons/icager")

library(icager)
dx <- simple()

specify(dx)
printscheme(dx)
plotit(dx)

dmodel = dx %>%
  filter(contingency %in% 5:14) %>%
  mutate(visitduration = difftime(end, start, units = "secs")) %>%
  filter(visitduration > 2, rp > 0)
