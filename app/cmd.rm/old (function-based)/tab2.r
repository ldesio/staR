#syntax varlist

tab2 <- function(cmd) {
	HTML.title(paste ("Cross-tabulation of <span class='badge'><em>",cmd$varlist[2], "</em></span> (",varlabel(cmd$varlist[2]),") by <span class='badge'><em>",cmd$varlist[1],"</em></span> (",varlabel(cmd$varlist[1]),")"), HR=2)

	# variable names
	cols = varlabel(cmd$varlist[2])
	rows = varlabel(cmd$varlist[1])

	# crosstab
	tbl <- table(star.data[,cmd$varlist[1]],star.data[,cmd$varlist[2]])
	
	# this might be moved to an implementation of the "numlabel" command
	if (is.factor(star.data[,cmd$varlist[1]])) {
		labs <- cbind(attributes(star.data)$label.table[[cmd$varlist[1]]])
		numlabs <- paste(labs, rownames(labs), sep=". ")
		rownames(tbl) <- rbind(cbind(numlabs))
	}
	
	# this might be moved to an implementation of the "numlabel" command
	if (is.factor(star.data[,cmd$varlist[2]])) {
		labsc <- cbind(attributes(star.data)$label.table[[cmd$varlist[2]]])
		numlabsc <- paste(labsc, rownames(labsc), sep=". ")
		colnames(tbl) <- rbind(cbind(numlabsc))
	}	
	
	# prop.table(mytable) # cell percentages
	# prop.table(mytable, 1) # row percentages
	# prop.table(mytable, 2) # column percentages 


	#row marginals
	rowmarg <- margin.table(tbl,1)
	tbl <- cbind(tbl,rowmarg)
	colnames(tbl)[ncol(tbl)] <- "TOTAL"

	#col marginals
	colmarg <- margin.table(tbl,2)
	tbl <- rbind(tbl,colmarg)
	rownames(tbl)[nrow(tbl)] <- "TOTAL"

	HTML.title("Counts", HR=3)
	HTML(tbl, classfirstline=paste("\"",varlabel(cmd$varlist[2]),"\""), classfirstcolumn=paste("\"",varlabel(cmd$varlist[1]),"\""), classtable="crosstab")
	
	if (cmd$options!="") {
		if (grepl("row",cmd$options)) {
			HTML.title("Row percentages", HR=3)
			HTML(rowfreqtable(tbl)*100.00, classfirstline=paste("\"",varlabel(cmd$varlist[2]),"\""), classfirstcolumn=paste("\"",varlabel(cmd$varlist[1]),"\""), classtable="crosstab")
		}
		if (grepl("col",cmd$options)) {
			HTML.title("Column percentages", HR=3)
			HTML(colfreqtable(tbl)*100.00, classfirstline=paste("\"",varlabel(cmd$varlist[2]),"\""), classfirstcolumn=paste("\"",varlabel(cmd$varlist[1]),"\""), classtable="crosstab")
		}
		if (grepl("cel",cmd$options)) {
			HTML.title("Total percentages", HR=3)
			HTML(cellfreqtable(tbl)*100.00, classfirstline=paste("\"",varlabel(cmd$varlist[2]),"\""), classfirstcolumn=paste("\"",varlabel(cmd$varlist[1]),"\""), classtable="crosstab")
		}
	}	
}
rowfreqtable <- function(table) {
	newtab <- table
	for (i in 1:nrow(newtab)) {
	  for (j in 1:ncol(newtab)) {
		newtab[i,j] = newtab[i,j] / newtab[i,ncol(newtab)]
     	 }
	}
	return (newtab)
}
colfreqtable <- function(table) {
	newtab <- table
	for (i in 1:nrow(newtab)) {
	  for (j in 1:ncol(newtab)) {
		newtab[i,j] = newtab[i,j] / newtab[nrow(newtab),j]
     	 }
	}
	return (newtab)
}
cellfreqtable <- function(table) {
	newtab <- table
	for (i in 1:nrow(newtab)) {
	  for (j in 1:ncol(newtab)) {
		newtab[i,j] = newtab[i,j] / newtab[nrow(newtab),ncol(newtab)]
     	 }
	}
	return (newtab)
}