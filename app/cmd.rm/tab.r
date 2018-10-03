#syntax varlist
# now automatically invoking tab1: when tab2 is implemented, should choose based on the number of variables in .varlist.

if (length(cmd$varlist)>1) {
	source(file="cmd.rm/tab2.R")

} else {
	source(file="cmd.rm/tab1.R")

}

