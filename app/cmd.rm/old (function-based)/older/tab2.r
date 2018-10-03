source(file="cmd/_star_lib.R")

cmd <- star_parse_stata_command("varlist")

HTML.title(paste ("Cross-tabulation of <span class='badge'><em>",cmd$varlist[2], "</em></span> (",varlabel(cmd$varlist[2]),") by <span class='badge'><em>",cmd$varlist[1],"</em></span> (",varlabel(cmd$varlist[1]),")"), HR=2)

# variable names
cols = varlabel(cmd$varlist[2])
rows = varlabel(cmd$varlist[1])

HTML(cols)
# HTML(rows)

# crosstab
tbl <- table(data[,cmd$varlist[1]],data[,cmd$varlist[2]])



# prop.table(mytable) # cell percentages
# prop.table(mytable, 1) # row percentages
# prop.table(mytable, 2) # column percentages 

if ('row' %in% names(cmd$options)) {
	tbl <- prop.table(tbl, 1)
}

#row marginals
rowmarg <- margin.table(tbl,1)

tbl <- cbind(tbl,rowmarg)

#col marginals
colmarg <- margin.table(tbl,2)

tbl <- rbind(tbl,colmarg)

rownames(tbl)[length(rowmarg)+1] <- "TOTAL"
colnames(tbl)[length(colmarg)] <- "TOTAL"


HTML(tbl)

