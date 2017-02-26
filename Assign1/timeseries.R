
library(ggplot2)
library(ggTimeSeries)
library(quantmod)
library(dygraphs)
library(xts)
library(quantmod)
library(highcharter)

# Q3に関しては基本的にこれだけで十分

# compare the exchange rates of USD/JPY and AUD/JPY
# x,yどちらもplotでも出るが、interactive modeではない。
x <- getSymbols("AUD/JPY", src = "oanda", auto.assign = FALSE)
y <- getSymbols("GBP/USD", src = "oanda", auto.assign = FALSE)

# Bollinger's bandを作る
x.BBands.ll <- BBands(x)$dn
x.BBands.ul <- BBands(x)$up
x.BBands.m <- BBands(x)$mavg
y.BBands.ll <- BBands(y)$dn
y.BBands.ul <- BBands(y)$up
y.BBands.m <- BBands(y)$mavg

# さすがにすごくて草生える
# xがblue,yがgreen
# Bollinger's bandは普通にadd seriesするっていう
hc <- highchart(type="stock") %>% 
  hc_title(text="Charting Exchange Rates") %>% 
  hc_subtitle(text = "Data extracted using quantmod package") %>% 
  hc_yAxis_multiples(
    list(top = "0%", height = "50%", offset=0, opposite=TRUE, lineWidth=2),
    list(top = "50%", height = "50%", offset=0, opposite=TRUE, lineWidth=2)
  )%>%
  hc_add_series(x, id = "audjpy", yAxis=0, color="blue") %>%
  hc_add_series(x.BBands.ll, id = "audjpy.l", yAxis=0, color="black",dashStyle='shortdash') %>%
  hc_add_series(y, id = "gbpusd", yAxis=1, color="green") %>%
  hc_add_theme(hc_theme_538())

hc




# documentの各種例
highchart() %>%
  hc_yAxis_multiples(
    list(top = "0%", height = "50%", lineWidth = 3),
    list(top = "30%", height = "50%", offset = 0,
         showFirstLabel = FALSE, showLastLabel = FALSE)
  ) %>%
  hc_add_series(data = rnorm(10)) %>%
  hc_add_series(data = rexp(10), type = "spline", yAxis = 1)

highchart() %>%
  hc_yAxis_multiples(create_yaxis(naxis = 2, heights = c(1, 5)),
                     list(opposite=FALSE)) %>%
  hc_add_series(data = c(1,3,2), yAxis = 0) %>%
  hc_add_series(data = c(20, 40, 10), yAxis = 1) %>%
  hc_add_theme(hc_theme_538())

highchart() %>%
  hc_yAxis_multiples(create_yaxis(naxis = 3, lineWidth = 2, title = list(text = NULL))) %>%
  hc_add_series(data = c(1,3,2)) %>%
  hc_add_series(data = c(20, 40, 10), yAxis = 1) %>%
  hc_add_series(data = c(200, 400, 500), type = "column", yAxis = 2) %>%
  hc_add_series(data = c(500, 300, 400), type = "column", yAxis = 2)














