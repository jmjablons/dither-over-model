sourceCpp("cpp/model/model_basic.cpp") #modelname
library(ggplot2)

plot_parammap_reward_side <- function(.tag, 
                                      max.beta = 5,
                                      a = dmodel, modelname = "basic"){
  temp <- expand.grid(alpha = seq(0,1,by = 0.01), 
                      beta = seq(0,max.beta, by = 0.1))
  dmouse <- a %>% filter(tag %in% .tag)
  temp$value <- apply(temp, 1, function(x){
    modelC(c(x[1],x[2]), dmouse$dooropened, side = dmouse$side)})
  temp_tick = plyr::round_any(min(temp$value), 10, ceiling) %>%
    `+`(c(0, 10, 100))
  temp_realparam <- remodel[[modelname]] %>%
    filter(tag %in% .tag) %>%
    select(grep("par.", names(.)))
  temp %>%
    filter(beta < max.beta) %>%
    ggplot(aes(x = alpha, y = beta, fill = value))+
    geom_tile()+
    stat_contour(aes(z = value), 
                 breaks = temp_tick, colour = "white", size = 0.01)+
    scale_fill_gradient(low = "black", high = "white")+
    metR::geom_text_contour(aes(z = value), check_overlap = TRUE, 
                            size = 2, 
                            stroke = 0.3, 
                            breaks = temp_tick)+
    #metR::geom_label_contour(aes(z = value), breaks = temp_tick)+
    geom_point(shape = 21, colour = "white", fill = NA,
               data = filter(temp, value %in% min(value)))+
    geom_point(aes(x = temp_realparam$par.alpha.pos, 
                   y = temp_realparam$par.beta), 
               shape = 8, colour = "white", fill = NA)+
    scale_x_continuous(limits = c(0,1), 
                       expand = c(0,0), 
                       breaks = c(0,1))+
    scale_y_continuous(limits = c(0, max.beta), 
                       expand = c(0,0), 
                       breaks = c(0, max.beta))+
    theme_classic()+
    theme(legend.position = "none")+
    labs(x = latex2exp::TeX("$\\alpha$"), y = latex2exp::TeX("$\\beta$"))}

{tplot <- list()
for(i in 1:14){
  m = unique(dmodel$tag)[i]
  tplot[[i]] = plot_parammap_reward_side(m)}}

ggsave("../inteli-black/result/figure/parammap_basic.pdf", 
       plot = patchwork::wrap_plots(tplot, ncol = 3), 
       device = cairo_pdf, 
       width = 12, height = 18, units = "cm", scale = 1.3)
