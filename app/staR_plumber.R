# retrieve directory of this script
this_file = gsub("--file=", "", commandArgs()[grepl("--file", commandArgs())])
if (length(this_file) > 0){
  wd <- paste(head(strsplit(this_file, '[/|\\]')[[1]], -1), collapse = .Platform$file.sep)
}else{
  wd <- dirname(rstudioapi::getSourceEditorContext()$path)
}

print(wd)

#sets as current working dir
setwd(wd)

# setwd("M:/staR/JS/Rengine")
library(plumber)
library(jsonlite)
# library(tidyverse)
svr <- plumber::plumb("api.R")
s <- svr$run(host='0.0.0.0',port=8000)




