#syntax varlist

#PROBLEM: DOES NOT LOAD rownames


tab1 <- function(cmd) {
	for (name in cmd$varlist) {
		HTML.title(paste ("Frequency distribution of <span class='badge'>",name,"</span> (",varlabel(name),")"), HR=2)
	  
		# frequency distribution
		tbl <- table(star.data[,name])
		rel <- prop.table(tbl)

		#TODO remove rows with zero cases

		final <- cbind( Freq.=tbl, Percent=prop.table(tbl)*100, Cum.=cumsum(rel)*100)
		
		# this might be moved to an implementation of the "numlabel" command
		if (is.factor(star.data[,name])) {
			labs <- cbind(attributes(star.data)$label.table[[name]])
			# HTML(final)
			
			numlabs <- paste(labs, rownames(labs), sep=". ")
			# HTML(final)

			rownames(final) <- rbind(cbind(numlabs))
		}


		# totals
		totals <- cbind(sum(final[,1]),sum(final[,2]),"")
		rownames(totals) <- "Total"
		
		# rounding
		final[,2] <- round(final[,2],digits=numdigits)
		final[,3] <- round(final[,3],digits=numdigits)
		
		# combining w/ totals
		final <- rbind(final,totals)
		
		# adding variable label???
		# colnames(final) <- c(varlabel(name),"Freq.", "Percent", "Cum.")
		# rownames(final) <- NULL
		
		HTML(final)

	}
}

