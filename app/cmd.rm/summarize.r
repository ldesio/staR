#syntax varlist
pandoc.header("Summary statistics", 3)

ret <- matrix(, nrow = length(cmd$varlist), ncol = 5)
colnames(ret) = c("Obs", "Mean" , "Std. Dev." , "Min" , "Max" )
rownames(ret) = cmd$varlist

i <-0
for (name in cmd$varlist) {
	i <- i + 1
	var <- star.data[,name]
	if (is.factor(var)) {
		var <- as.numeric((var))
	}
	ret[i,1] = sum(!is.na(var))
	ret[i,2] = mean(var,na.rm = TRUE)
	ret[i,3] = sd(var,na.rm = TRUE)
	ret[i,4] = min(var,na.rm = TRUE)
	ret[i,5] = max(var,na.rm = TRUE)
}


pander(ret)