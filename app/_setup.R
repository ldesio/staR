want = c("plumber", "tidyverse", "foreign", "knitr", "summarytools", "expss", "haven", "stargazer", "factors")
have = want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
# junk = lapply(want, library, character.only = TRUE)
rm(list=ls())
