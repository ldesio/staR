varindex <- function(arg1) {
	return(match(arg1,attributes(star.data)$names))
}

varlabel <- function(arg1) {
	return(attributes(star.data)$var.labels[varindex(arg1)])
}
varname <- function(arg1) {
	return(attributes(star.data)$names[varindex(arg1)])
}
var <- function(name) {
  return(star.data[name])
}

star_panel <- function(string) {
	HTML(paste("<h2>",string,"</h2>")) 
}

star_parse_stata_command <- function (signature) {
	pos_firstspace <- regexpr (' ',star.cmdline)
	star.cmd <- substring(star.cmdline,1,pos_firstspace-1)
	star.cmd.paramline <- substring(star.cmdline,pos_firstspace+1)
	
	if (signature=="filename") {
		words <- strsplit(star.cmd.paramline, " ")[[1]]
		star.cmd.filename <- gsub("\"", "", words[1])
		
		newList <- list ("command"=star.cmd,"paramline"=star.cmd.paramline,"filename"=star.cmd.filename);
	
		
	} else if (signature=="varlist") {
		
		pos_firstcomma <- regexpr (',',star.cmd.paramline)
		if (pos_firstcomma==-1) {
			varstring <- star.cmd.paramline
			star.cmd.options <- ""
	
		} else {
			varstring <- substring(star.cmd.paramline,1,pos_firstcomma-1)
			star.cmd.options <- substring(star.cmd.paramline,pos_firstcomma+1)
		}
		
		ifclause <- ""
		pos_if <- regexpr ('if',varstring)
		if (pos_if!=-1) {
			ifclause <- substring(varstring,pos_if+3)
			varstring <- substring(varstring,1,pos_if-1)
		}

		star.cmd.varlist <- star_resolve_varlist(varstring)
		newList <- list ("command"=star.cmd,"paramline"=star.cmd.paramline,"varlist"=star.cmd.varlist,"options"=star.cmd.options,"ifclause"=ifclause);
	
	}
	
	return (newList)
}
star_resolve_varlist <- function(string) {
	retVal = ""
	
	# has * ?
	
	if (grepl("[*]",string)) {
		retVal <- subset(names(star.data),grepl(glob2rx(string),names(star.data))) 
	} else {
		retVal <- strsplit(string, " ")[[1]]
	}
	
	return(retVal)
}

model <- function (varlist) {

	outcome <- varlist[1]
	predictors <- paste(varlist[2:length(varlist)],collapse=" + ")
	modelsyntax <- paste(outcome, " ~ ", predictors)
	pretty_predictors <- paste(varlist[2:length(varlist)],collapse=", ")

	newList <- list ("outcome"=outcome,"predictors"=predictors,"syntax"=modelsyntax,"pretty_predictors"=pretty_predictors);
	return (newList)

}

enforce_packages <- function(list.of.packages) {

	# list.of.packages <- c("ggplot2", "Rcpp")
	new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
	if(length(new.packages)) install.packages(new.packages)

}

asNumeric <- function(x) as.numeric(as.character(x))
factorsNumeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)],   
                                                   asNumeric))

numdigits = 2