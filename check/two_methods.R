dmodel = dmodel %>% mutate(side = ceiling(corner/2)-1)

temp <- wrapmodel(alpha.pos = init$default, 
          beta = init$beta, alpha.neg = init$default,
          .input = dmodel)
temp = temp %>% util_finish("dual")

library(ggplot2)
temp %>%
  select(tag, par.alpha.pos, par.alpha.neg, par.beta, aic, name) %>%
  tidyr::gather(param, value, -tag, -name) %>%
  rbind(remodel$dual %>%
              select(tag, par.alpha.pos, par.alpha.neg, par.beta, aic, name) %>%
              mutate(name = "dual_standard") %>%
              tidyr::gather(param, value, -tag, -name)) %>%
  ggplot(aes(x = name, y = value))+
  facet_wrap(~param, scales = "free")+
  geom_boxplot(outlier.colour = NA)+
  geom_jitter(width = .2)+
  theme(axis.title = element_blank())

temp %>%
  select(tag, modelc = value) %>%
  left_join(remodel$dual %>%
              select(tag, modelr = value))
