varindex <- function(arg1) {
	return(match(arg1,attributes(star.data)$names))
}

varlabel <- function(arg1) {
	return(attributes(star.data)$var.labels[varindex(arg1)])
}
varlabeltable <- function(arg1) {
	name <- attributes(star.data)$val.labels[varindex(arg1)]
	return (attributes(star.data)$label.table[name])
}
varname <- function(arg1) {
	return(attributes(star.data)$names[varindex(arg1)])
}
var <- function(name) {
  return(star.data[name])
}

star.rowlabels <- function(name) {
	
	labs <- levels(star.data[,name])
	return (labs)
	#numlabs <- paste(labs, rownames(labs), sep=". ")

	#return (numlabs)
	
}

star.numberedlabels <- function (var,labellist) {
	retVal <- labellist
	
	lt <- varlabeltable(var)
	pippo <- paste(lt[[1]],names(lt[[1]]),sep=". ")
	names(pippo) <- names(lt[[1]])

	# HTML(pippo)
	for (i in 1:length(labellist)) {
		#HTML(paste(labellist[i],"***",pippo[labellist[i]]))
		retVal[i] <- pippo[labellist[i]]
	}


	return (retVal)	
}
star.numberedlevels <- function(var) {
	#TEST
	lt <- varlabeltable(var)

	pippo <- paste(lt[[var]],names(lt[[var]]),sep=". ")
	names(pippo) <- names(lt[[var]])

	# dangerous? better to use a loop on actual levels, retrieving levels with pippo[levels(x)[indice]]
	#levels(star.data[,var]) <- pippo
	
	#HTML(levels(star.data[,var]))

	for (i in 1:nlevels(star.data[,var]) ) {
		levels(star.data[,var])[i] <- pippo[levels(star.data[,var])[i]]
	}
	return(levels(star.data[,var]))

}





star_panel <- function(string) {
	HTML(paste("<h2>",string,"</h2>")) 
}
star_error <- function(string) {
	HTML(paste("<div class='alert alert-danger' role='alert'>",string,"</div>"))
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
		#pos_if <- regexpr ('if',varstring)
		#if (pos_if!=-1) {
		#	ifclause <- substring(varstring,pos_if+3)
		#	varstring <- substring(varstring,1,pos_if-1)
		#}

		star.cmd.varlist <- star_resolve_varlist(varstring)
		newList <- list ("command"=star.cmd,"paramline"=star.cmd.paramline,"varlist"=star.cmd.varlist,"options"=star.cmd.options,"ifclause"=ifclause);
	
	} else {
		newList <- list ("command"=star.cmd,"paramline"=star.cmd.paramline);
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

# Provides a data matrix of all-numeric variables, with "i." variables resolved
# (R by default treats them as categorical)
resolved_data_matrix <- function(varlist) {
  
  # remove any requested factor variables for obtaining data matrix
  cleanvarlist = gsub("i\\.","",varlist)
  
  # obtain a copy of the relevant variables, where all factor variables are converted to numeric
  matrix <- data.frame(data.matrix(star.data[,cleanvarlist]))
  
  # restore factor for requested factor variables
  index = 0
  for (var in varlist){
    index = index + 1
    if (substring(var,1,2)=="i.") {
      matrix[,cleanvarlist[index]] = star.data[,cleanvarlist[index]]
    }
  }
  return(matrix)
}

resolved_model_syntax <- function(model) {
  return(gsub("i\\.","",model))
}
enforce_packages <- function(list.of.packages) {

	# list.of.packages <- c("ggplot2", "Rcpp")
	new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
	if(length(new.packages)) {
	  install.packages(new.packages, repos='http://cran.us.r-project.org')
	}
}

star.source <- function(theLine) {

	if (grepl(" ",theLine)) {

		pos_firstspace <- regexpr (' ',theLine)
		command <- substring(theLine,1,pos_firstspace-1)

		script <- paste("cmd.rm/",command,".r",sep="")

    retVal <- ""
    
		if (file.exists(script)) {
			
			# read lines of script file
			x <- scan(script, what="", sep="\n")
			
			# assumes first line contains a "syntax" clause
			syntaxrow <- x[1]

			# loads content of "syntax" clause: everything after the "syntax" keyword
			syntaxspec <- substring(syntaxrow,regexpr (' ',syntaxrow)+1)

			# uses such "syntax" clause spec, to correctly parse the received Stata command line,
			#	and appropriately populates the "cmd" object
			
			thiscmd <- paste("cmd <- star_parse_stata_command(\"",syntaxspec,"\")",sep="",collapse="")

			retVal <- paste(retVal,thiscmd,sep="\n")
			
			cmd <<- star_parse_stata_command(syntaxspec)
			# HTML.title("****",HR=2)
					
			if (FALSE) { # applies IF clause
			if (exists("cmd$ifclause")) {
				if (cmd$ifclause != "") {
					detach(star.data)
					
					# no math operators (including < >) on factors.
					# Should list all involved vars and convert them to copies, using as.numeric(levels(f))[f]
					fz <- factorsNumeric(star.data)
					sel <- fz[which(eval(parse(text=cmd$ifclause)))]
					
					HTML.title(fz, HR=2)
					HTML.title(sel,HR=2)

					#attach(subset(star.data,eval(parse(text=cmd$ifclause))))
					attach(star.data[sel])
				}
			}
			}

			# loads the script file, so that the function becomes available
			# source(file=script)
				
			retVal <- paste(retVal,readChar(script, file.info(script)$size),sep="\n")


			# calls the function
			# eval(parse(text=paste(command,"(cmd)")))
			
			if (exists("cmd$ifclause")) {
				if (cmd$ifclause != "") {
					detach()
					attach(star.data)
				}
			}		
		} else {
      return(theLine)
		}

    return(retVal)
	} else {
			return(theLine)
	}

	return(theLine)
}

errorPanel <- function(err) {
  cat(errorPanel.return(err))
}

errorPanel.return <- function(err) {
  return(paste0("<div class='alert alert-danger'><h4>Error!</h4>","<p>",err,"</p></div>"))
}


warningPanel <- function(err) {
  cat("\r\n\r\n<div class='alert alert-warning'><h4>Warning!</h4>")
  cat(paste("<p>",err,"</p></div>"))
}

asNumeric <- function(x) as.numeric(as.character(x))
factorsNumeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)],   
                                                   asNumeric))

numdigits = 2