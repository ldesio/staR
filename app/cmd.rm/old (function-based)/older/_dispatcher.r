source(file="cmd/_star_lib.R")


pos_firstspace <- regexpr (' ',star.cmdline)
theLine <- substring(star.cmdline,pos_firstspace+1)

if (grepl(" ",theLine)) {

	pos_firstspace <- regexpr (' ',theLine)
	command <- substring(theLine,1,pos_firstspace-1)

	script <- paste("cmd/",command,".r",sep="")

	if (file.exists(script)) {
		star.cmdline <- theLine
		source(file=script)
	} else {
		eval(parse(text=theLine))
	}

} else {
		eval(parse(text=theLine))
}