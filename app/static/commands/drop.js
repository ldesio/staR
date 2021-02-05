input = parseStataSyntaxFromCommandLine({parseType:"varlist"});

loadDataset({
	input:input,
	command: datasetUse,
	postProcess: "stardata <- dplyr::select(.data=stardata, -c(" + input.vars[0] + "));\n" 
});
appendContent("Variable dropped.");