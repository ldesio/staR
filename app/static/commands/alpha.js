input = parseStataSyntaxFromCommandLine({parseType:"varlist"});
  
  
  var theVars = "'" + input.vars.join("','") + "'";

  var commands = [
		"subset <- stardata[,c("+theVars+")];",
		"res <- alpha(subset);",
		"cat(paste0('<h3>Cronbach's alpha:</h3>'));",
		"cat('<style>.summarytable {width:100%} .summarytable td {padding:5px}</style>');",
		"cat(knitr::knit_print(knitr::kable(res$total,format='html', table.attr = 'class=\"summarytable\"')))",
		"cat(paste0('<h3>Reliability if an item is dropped:</h3>'));",
		"cat(knitr::knit_print(knitr::kable(res$alpha.drop,format='html', table.attr = 'class=\"summarytable\"')))"
	]
  
  runPackage({
  	// title: "Cronbach's alpha: " + input.vars.join(", "),
  	input:input,
  	rPackages:["psych"],
  	rCommands: commands
  });	


