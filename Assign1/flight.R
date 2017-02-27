library(devtools)

install.packages('nycflights13')
install.packages('ffbase')
install.packages('biglm')
install.packages('pROC')
devtools::install_github("edwindj/ffbase2")
install.packages('chron')

library(nycflights13)
library(ffbase)
library(ffbase2)
library(biglm)
library(pROC)

typeof(flights)

flightff



# ifelseの例
data(iris)
ffiris <- as.ffdf(iris)
ffifelse(ffiris$Sepal.Length < 5, TRUE, NA)

