#syntax varlist

pandoc.header(paste0("Histogram of *",cmd$varlist[1], "* (",varlabel(cmd$varlist[1]),")"), 3)

var <- star.data[,cmd$varlist[1]]

if (is.factor(var)) {
	barplot(prop.table(table(var)))
} else {
	hist(var,main=cmd$varlist[1], xlab=cmd$varlist[1], freq=FALSE)
}
