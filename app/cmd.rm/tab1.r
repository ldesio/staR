#syntax varlist

#PROBLEM: DOES NOT LOAD rownames


	for (name in cmd$varlist) {
	  
	  cat("\r\n\r\n")
    
    #+ results='asis', echo=FALSE
    pandoc.header(paste0("Frequency distribution of *",name,"* (",varlabel(name),")"),3)
	#cat(paste ("<p class='text-primary'>Frequency distribution of <span class='badge'>",name,"</span> (",varlabel(name),")</p>"))
    #cat("\r\n\r\n")
    
    
		# frequency distribution
		tbl <- table(star.data[,name])
		rel <- prop.table(tbl)
		final <- cbind( Freq.=tbl, Percent=prop.table(tbl)*100, Cum.=cumsum(rel)*100)
		
		# adding codes to labels
		if (is.factor(star.data[,name])) rownames(final) <- star.numberedlabels(name, rownames(final))

		# remove values not observed in the dataset (as in Stata)
		if (nrow(final) > 1) final <- final[final[,1]!=0,] 

		tryCatch({
		
			# totals
			totals <- cbind(sum(final[,1]),sum(final[,2]),"")
			rownames(totals) <- "Total"
			
			# rounding
			final[,2] <- round(final[,2],digits=numdigits)
			final[,3] <- round(final[,3],digits=numdigits)
			
			# combining w/ totals
			final <- rbind(final,totals)
      
			cat("\r\n\r\n")
      
			#+ results='asis', echo=FALSE  
			stargazer(final, type="html")  
      cat("\r\n\r\n")
      
			
      
      
		}, error = function(err) {
			errorPanel(err)
		}
		)


	}


