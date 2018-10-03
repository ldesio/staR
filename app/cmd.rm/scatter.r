#syntax varlist

pandoc.header(paste0(
	"Scatterplot of *",cmd$varlist[1], "* (",varlabel(cmd$varlist[1]),
	") by *",cmd$varlist[2], "* (",varlabel(cmd$varlist[2]),")"), 3)

# obtains an all-numeric copy of the relevant variables
matrix <- data.frame(data.matrix(star.data[,cmd$varlist]))
# scatterplot
plot(matrix[,c(cmd$varlist[2],cmd$varlist[1])])

