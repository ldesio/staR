source(file="cmd/_star_lib.R")

cmd <- star_parse_stata_command("varlist")

for (name in cmd$varlist) {
	HTML.title(paste ("Frequency distribution of <span class='badge'>",name,"</span> (",varlabel(name),")"), HR=2)
  
  	# frequency distribution
	tbl <- table(data[,name])
	rel <- prop.table(tbl)
	final <- cbind( Freq.=tbl, Percent=prop.table(tbl)*100, Cum.=cumsum(rel)*100)
	
	# totals
	totals <- cbind(sum(final[,1]),sum(final[,2]),"")
	rownames(totals) <- "Total"
	
	# rounding
	final[,2] <- round(final[,2],digits=numdigits)
	final[,3] <- round(final[,3],digits=numdigits)
	
	# combining w/ totals
	final <- rbind(final,totals)
	
	# questo in realtà va spostato nel comando "numlabel"
	if (is.factor(data[,name])) {
		labs <- cbind(attributes(data)$label.table[[name]])
		numlabs <- paste(labs, rownames(labs), sep=". ")
		rownames(final) <- rbind(cbind(numlabs),rownames(totals))
	}
	
	# adding variable label???
	# colnames(final) <- c(varlabel(name),"Freq.", "Percent", "Cum.")
	# rownames(final) <- NULL
	
	HTML(final)

  





}

