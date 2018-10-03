source(file="cmd/_star_lib.R")


#pos_firstspace <- regexpr (' ',star.cmdline)
#theLine <- substring(star.cmdline,pos_firstspace+1)
theLine <- star.cmdline


if (grepl(" ",theLine)) {

	pos_firstspace <- regexpr (' ',theLine)
	command <- substring(theLine,1,pos_firstspace-1)

	script <- paste("cmd/",command,".r",sep="")

	if (file.exists(script)) {
		# removes the initial "_dispatcher" word: remove when updating Java code
		# star.cmdline <- theLine
		
		# read lines of script file
		x <- scan(script, what="", sep="\n")
		
		# assumes first line contains a "syntax" clause
		syntaxrow <- x[1]

		# loads content of "syntax" clause: everything after the "syntax" keyword
		syntaxspec <- substring(syntaxrow,regexpr (' ',syntaxrow)+1)

		# uses such "syntax" clause spec, to correctly parse the received Stata command line,
		#	and appropriately populates the "cmd" object
		cmd <- star_parse_stata_command(syntaxspec)
		# HTML.title("****",HR=2)
				
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

		# loads the script file, so that the function becomes available
		source(file=script)

		# calls the function
		eval(parse(text=paste(command,"(cmd)")))
		
		if (exists("cmd$ifclause")) {
			if (cmd$ifclause != "") {
				detach()
				attach(star.data)
			}
		}		
	} else {
		eval(parse(text=theLine))
	}

} else {
		eval(parse(text=theLine))
}
