temp <- expand.grid(alpha = seq(0,1,by = 0.01), beta = seq(0,10, by = 0.1))

dhero <- dmodel %>%
  filter(tag %in% unique(dmodel$tag)[6])

sourceCpp("cpp/model/model_basic.cpp")
temp$value <- apply(temp, 1, function(x){
  modelC(c(x[1],x[2]), dhero$dooropened, side = dhero$side)})

library(ggplot2)
library(metR)
temp %>%
  filter(beta < 5) %>%
  ggplot(aes(x = alpha, y = beta, fill = value))+
  geom_tile()+
  stat_contour(aes(z = value), 
               breaks = c(850, 860, 900, 1200, 1700), colour = "white", size = 0.01)+
  scale_fill_gradient(low = "black", high = "white")+
  #metR::geom_text_contour(aes(z = value), stroke = 0.3, breaks = c(850, 860, 900, 1200))
  metR::geom_label_contour(aes(z = value), breaks = c(850, 860, 900, 1200, 1700))

temp$value %>% min()
