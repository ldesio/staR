# setwd("M:/staR/JS/Rengine")
setwd("/staR/app")
library(jsonlite)
library(plumber)
library(magrittr)
#library(foreign) 
#library(knitr)
# library(summarytools)
#library(expss)
#library(stargazer)

options(digits=8)
svr <- plumber::plumb("api.R")
s <- svr$run(host='0.0.0.0',port=80)




