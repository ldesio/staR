#syntax filename
#POSTPROCESS update_vars

if (cmd$filename=="xx") cmd$filename <- file.choose()


#+ results='asis', echo=FALSE 
cat(paste("Opening dataset <span class='label label-default'>",cmd$filename,"</span>",sep=""))
# cat(paste("Opening dataset **",cmd$filename,"**",sep=""))

#+ results='asis', echo=TRUE 
library(foreign)
	
# Detaching and removing any previous "star.data" object
tryCatch({ 
	detach(star.data)
  rm(star.data)
	}
  , error = function(err) {cat(" ")}, warning = function(err) {cat(" ")}
)

# Loading dataset, registering the "star.data" object in the global scope (double arrow), attaching.
tryCatch({ 
  star.data <<- read.dta(cmd$filename)
	attach(star.data)
	cat(paste("\r\n\r\n<span class='label label-success'>",ncol(star.data),"</span> variables, <span class='label label-success'>",nrow(star.data),"</span> observations.",sep=""))
}, error = function(err) {errorPanel(err)}, warning = function(err) {warningPanel(err)}
)






# + results='asis', echo=FALSE 

	
	