result_model
result_model_ralone <- readRDS(file.choose())

model_name <- "hybrid_original"

tplot1 <- ggplot(aes(x = diff), data = temp) +
  geom_density(fill = "gray")+
  #geom_histogram(binwidth = 1, bins = 83)+
  labs(y = "density", x = "difference", 
       caption = paste0("model: ", model_name, "\n",
                        "inteli-reward dataset, N = 83\n median: ",
                        parsesummary(temp$diff)))

temp <- result_model_ralone[[model_name]] %>%
  select(tag, ralone = par.alpha.pos) %>%
left_join(
result_model[[model_name]] %>%
  select(tag, cpp = par.alpha.pos)) %>%
  mutate(diff = cpp - ralone) 

tplot1 <- ggplot(aes(x = diff), data = temp) +
  geom_density(fill = "gray")+
  #geom_histogram(binwidth = 1, bins = 83)+
  labs(y = "density", x = "difference", 
       caption = paste0("model: ", model_name, "\n",
                        "inteli-reward dataset, N = 83\n median: ",
                        parsesummary(temp$diff)))
tplot2 <- temp %>%
  select(-diff) %>%
  tidyr::gather(method, value, -tag) %>%
ggplot(aes(x = method, y = value, group = tag)) +
  geom_line(alpha = .1)+
  geom_jitter(width = .01)+
  labs(y = "par.alpha.pos",
       caption = paste0("model: ", model_name, "\n",
                        "inteli-reward dataset, N = 83\n median: ",
                        parsesummary(temp$diff)))

temp <- result_model_ralone[[model_name]] %>%
  select(tag, ralone = par.alpha.neg) %>%
  left_join(
    result_model[[model_name]] %>%
      select(tag, cpp = par.alpha.neg)) %>%
  mutate(diff = cpp - ralone) 

tplot3 <- ggplot(aes(x = diff), data = temp) +
  geom_density(fill = "gray")+
  #geom_histogram(binwidth = 1, bins = 83)+
  labs(y = "density", x = "difference", 
       caption = paste0("model: ", model_name, "\n",
                        "inteli-reward dataset, N = 83\n median: ",
                        parsesummary(temp$diff)))
tplot4 <- temp %>%
  select(-diff) %>%
  tidyr::gather(method, value, -tag) %>%
  ggplot(aes(x = method, y = value, group = tag)) +
  geom_line(alpha = .1)+
  geom_jitter(width = .01)+
  labs(y = "par.alpha.neg",
       caption = paste0("model: ", model_name, "\n",
                        "inteli-reward dataset, N = 83\n median: ",
                        parsesummary(temp$diff)))

temp <- result_model_ralone[[model_name]] %>%
  select(tag, ralone = par.beta) %>%
  left_join(
    result_model[[model_name]] %>%
      select(tag, cpp = par.beta)) %>%
  mutate(diff = cpp - ralone) 

tplot5 <- ggplot(aes(x = diff), data = temp) +
  geom_density(fill = "gray")+
  #geom_histogram(binwidth = 1, bins = 83)+
  labs(y = "density", x = "difference", 
       caption = paste0("model: ", model_name, "\n",
                        "inteli-reward dataset, N = 83\n median: ",
                        parsesummary(temp$diff)))
tplot6 <- temp %>%
  select(-diff) %>%
  tidyr::gather(method, value, -tag) %>%
  ggplot(aes(x = method, y = value, group = tag)) +
  geom_line(alpha = .1)+
  geom_jitter(width = .01)+
  labs(y = "par.beta",
       caption = paste0("model: ", model_name, "\n",
                        "inteli-reward dataset, N = 83\n median: ",
                        parsesummary(temp$diff)))

(tplot2 | tplot1) / (tplot4 | tplot3) / (tplot6 | tplot5)


# nll ---------------------------------------------------------------------

temp <- result_model_ralone[[model_name]] %>%
  select(tag, ralone = value) %>%
  left_join(
    result_model[[model_name]] %>%
      select(tag, cpp = value)) %>%
  mutate(diff = cpp - ralone) 

tplot7 <- ggplot(aes(x = diff), data = temp) +
  #geom_density(fill = "gray")+
  geom_histogram(bins = 83)+
  labs(y = "number of animals", x = "nll difference", 
       caption = paste0("model: ", model_name, "\n",
                        "inteli-reward dataset, N = 83\n median: ",
                        parsesummary(temp$diff)))

(function(x){
  list(
    mean(x),
    min(x),
    max(x))})(temp$diff)
