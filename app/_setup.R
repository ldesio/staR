want = c("plumber", "tidyverse", "foreign", "knitr", "summarytools", "expss", "haven", "stargazer", "labelled", "magrittr")
# "factors", 
# non-existing package name: it could be either "lfactors" or "forcats"
have = want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
# junk = lapply(want, library, character.only = TRUE)
rm(list=ls())
