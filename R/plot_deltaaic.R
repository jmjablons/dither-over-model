library(ggplot2)
library(scales)

asinh_trans <- function() {
  #as posted on stackoverflow
  #   https://kutt.it/huJptV
  trans_new("asinh",
            transform = asinh,
            inverse   = sinh)}

remodel %>% 
  purrr::map(~select(., name, aic, tag)) %>%
  bind_rows() %>%
  group_by(tag) %>%
  dplyr::group_split(keep = TRUE) %>%
  purrr::map(~ mutate(., delta = .$aic - .$aic[.$name %in% "basic"]))%>%
  dplyr::bind_rows() %>%
  
  ## plot ##
  ggplot(aes(x = name, y = delta)) +
  geom_boxplot(outlier.colour = NA)+
  geom_jitter(width = .1, pch = 21, fill = "gray")+
  geom_hline(yintercept = 0, linetype = "dotted")+
  theme(panel.spacing = unit(2, "lines"),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.x = element_blank(),
        axis.ticks.y = element_line(linetype = 'dashed'),
        axis.ticks.x = element_blank(),
        axis.line.x = element_blank(),
        legend.position = "none")+
  scale_y_continuous(
    trans = 'asinh',
    expand = c(0,0),
    limits = c(0, 10^4),
    breaks = c(-(10^(1:4)), 10^(1:4)),
    labels = latex2exp::TeX(c(paste("$-10^{",1:4, "}$", sep = ""),
                              paste("$10^{",1:4, "}$", sep = ""))))
