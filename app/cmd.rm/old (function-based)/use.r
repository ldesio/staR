#syntax filename
#POSTPROCESS update_vars

use <- function(cmd) {
	HTML.title(paste("Opening dataset <span class='badge'>",cmd$filename,"</span>"), HR=2)
	
	library(foreign)
	
	#NOTE: registering the "star.data" object in the global scope, through a double arrow
	star.data <<- read.dta(cmd$filename)
	attach(star.data)
	HTML(paste(ncol(star.data)," variables, ",nrow(star.data)," observations."))
}
