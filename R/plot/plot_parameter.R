remodel[["basic"]] %>%
  dplyr::select(tag, name, par.alpha) %>%
  tidyr::gather(param, value, -tag, -name) %>%
  ggplot(aes(x = param, y = value))+
  geom_boxplot(outlier.colour = NA)+
  geom_jitter(width = .2, pch = 21, fill = "gray")+
  facet_wrap(~name)+
  theme_classic()+
  scale_y_continuous(limits = c(0,1), breaks = c(0, .5, 1))
