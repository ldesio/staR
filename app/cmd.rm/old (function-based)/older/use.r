#POSTPROCESS update_vars

source(file="cmd/_star_lib.R")

library(foreign)
cmd <- star_parse_stata_command("filename")

star_panel(paste("Opening dataset <span class='badge'>",cmd$filename,"</span>"))

data <- read.dta(cmd$filename)
attach(data)
print(paste(ncol(data)," variables, ",nrow(data)," observations."))

