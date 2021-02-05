// always available for directly accessing the command line, even without parsing anything
console.log(currentCommandLine);


input = parseStataSyntaxFromCommandLine({parseType:"varlist"});
var theVars = "'" + input.vars.join("','") + "'";

runPackage({
	title: "Summary statistics",
	input: input,
	rPackages: ["stargazer","knitr","summarytools"],
	rCommands: [
		"subset <- data.frame(data.matrix(stardata[,c("+theVars+")]));", // subsets, and removes labels
		"ret <- summarytools::descr(subset,stats=c('n.valid','mean','sd','min','max'),transpose=TRUE);",
		"ret$Mean <- round(ret$Mean, digits=3); ret$Std.Dev <- round(ret$Std.Dev, digits=3);",
		"cat('<style>.summarytable {width:100%} .summarytable td {padding:2px}</style>');" +
		"cat(knitr::knit_print(knitr::kable(ret,format='html', table.attr = 'class=\"summarytable\"')))"
	]
});