# list.of.packages <- c("plumber", "foreign", "knitr", "summarytools","expss","stargazer")
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages)
want = c("plumber", "tidyverse", "foreign", "knitr", "summarytools", "expss", "haven", "stargazer")
have = want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
# junk = lapply(want, library, character.only = TRUE)
# rm(have,want,junk)
rm(have,want)
