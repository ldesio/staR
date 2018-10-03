varindex <- function(arg1) {
	return(match(arg1,attributes(data)$names))
}

varlabel <- function(arg1) {
	return(attributes(data)$var.labels[varindex(arg1)])
}
varname <- function(arg1) {
	return(attributes(data)$names[varindex(arg1)])
}
var <- function(name) {
  return(data[name])
}

star_panel <- function(string) {
	print(paste("<h2>",string,"</h2>")) 
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
			star.cmd.varlist <- strsplit(varstring, " ")[[1]]
			newList <- list ("command"=star.cmd,"paramline"=star.cmd.paramline,"varlist"=star.cmd.varlist);
	
		} else {
			varstring <- substring(star.cmd.paramline,1,pos_firstcomma-1)
			optionstring <- substring(star.cmd.paramline,pos_firstcomma+1)
			star.cmd.options <- strsplit(optionstring, " ")[[1]]
			star.cmd.varlist <- strsplit(varstring, " ")[[1]]
			newList <- list ("command"=star.cmd,"paramline"=star.cmd.paramline,"varlist"=star.cmd.varlist,"options"=star.cmd.options);
	
		}
		
	}
	
	return (newList)
}

model <- function (varlist) {

	outcome <- varlist[1]
	predictors <- paste(varlist[2:length(varlist)],collapse=" + ")
	modelsyntax <- paste("lm(",outcome, " ~ ", predictors,")")
	pretty_predictors <- paste(varlist[2:length(varlist)],collapse=", ")

	newList <- list ("outcome"=outcome,"predictors"=predictors,"syntax"=modelsyntax,"pretty_predictors"=pretty_predictors);
	return (newList)

}

enforce_packages <- function(list.of.packages) {

	# list.of.packages <- c("ggplot2", "Rcpp")
	new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
	if(length(new.packages)) install.packages(new.packages)

}


numdigits = 2