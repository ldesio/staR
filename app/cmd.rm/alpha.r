#syntax varlist
	
	enforce_packages(c("psych"))
	library("psych")
	
	items  <- unlist(strsplit(cmd$varlist, split=" "))
	itemdata <- star.data[items]
	
	result <- alpha(itemdata)
	
	pandoc.header("Cronbach's alpha",3);
	pander(result$total)
	pandoc.header("Item statistics",4);
	pander(result$item.stats)
	
	
	
	
	

	







