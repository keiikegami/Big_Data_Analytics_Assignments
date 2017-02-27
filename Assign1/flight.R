library(devtools)

install.packages('nycflights13')
install.packages('ffbase')
install.packages('biglm')
install.packages('pROC')
devtools::install_github("edwindj/ffbase2")

library(nycflights13)
library(ffbase)
library(ffbase2)
library(biglm)
library(pROC)

typeof(flights)

flightff <- ff(flights, filename="flightff")
