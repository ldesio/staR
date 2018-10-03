#syntax varlist


panderOptions("table.split.table",Inf)


 	
  panderOptions('knitr.auto.asis', FALSE)

  pandoc.header(paste0("Cross-tabulation of *",cmd$varlist[2], "* (",varlabel(cmd$varlist[2]),") by *",cmd$varlist[1],"* (",varlabel(cmd$varlist[1]),")"), 2)

 #  source("http://pcwww.liv.ac.uk/~william/R/crosstab.r")
 #  pandoc.header("Counts", 4)
 # 	tbl <- crosstab(star.data, row.vars = cmd$varlist[1], col.vars = cmd$varlist[2], type = "f")
 # 	pander(tbl$crosstab)
 # 	
 # 	if (cmd$options!="") {
 # 		if (grepl("row",cmd$options)) {
 # 			pandoc.header("Row percentages", 4)
 # 		  tbl <- crosstab(star.data, row.vars = cmd$varlist[1], col.vars = cmd$varlist[2], type = "r")
 # 		  pander(tbl$crosstab)
 # 		}
 # 		if (grepl("col",cmd$options)) {
 # 			pandoc.header("Column percentages", 4)
 # 		  tbl <- crosstab(star.data, row.vars = cmd$varlist[1], col.vars = cmd$varlist[2], type = "c")
 # 		  pander(tbl$crosstab)
 # 		}
 # 		if (grepl("cel",cmd$options)) {
 # 			pandoc.header("Total percentages", 4)
 # 		  tbl <- crosstab(star.data, row.vars = cmd$varlist[1], col.vars = cmd$varlist[2], type = "t")
 # 		  pander(tbl$crosstab)
 # 		}
 # 	}


# library(gmodels)
# CrossTable(star.data[cmd$varlist[2]],star.data[cmd$varlist[1]],prop.chisq=FALSE,chisq=FALSE)
# 
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

	# variable names
	cols = varlabel(cmd$varlist[2])
	rows = varlabel(cmd$varlist[1])

	# crosstab
	tbl <- table(star.data[,cmd$varlist[1]],star.data[,cmd$varlist[2]])

	if (is.factor(star.data[,cmd$varlist[1]])) rownames(tbl) <- star.numberedlabels(cmd$varlist[1], rownames(tbl))
	if (is.factor(star.data[,cmd$varlist[2]])) colnames(tbl) <- star.numberedlabels(cmd$varlist[2], colnames(tbl))

	#row marginals
	rowmarg <- margin.table(tbl,1)
	tbl <- cbind(tbl,rowmarg)
	colnames(tbl)[ncol(tbl)] <- "TOTAL"

	#col marginals
	colmarg <- margin.table(tbl,2)
	tbl <- rbind(tbl,colmarg)
	rownames(tbl)[nrow(tbl)] <- "TOTAL"

	if (!grepl("nofreq",cmd$options)) {
  	pandoc.header("Counts", 4)
  	pander(tbl)
	}

	if (cmd$options!="") {
		if (grepl("row",cmd$options)) {
			pandoc.header("Row percentages", 4)
			pander(rowfreqtable(tbl)*100.00)
		}
		if (grepl("col",cmd$options)) {
			pandoc.header("Column percentages", 4)
			pander(colfreqtable(tbl)*100.00)
		}
		if (grepl("cel",cmd$options)) {
			pandoc.header("Total percentages", 4)
			pander(cellfreqtable(tbl)*100.00)
		}
	}

