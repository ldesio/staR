input = parseStataSyntaxFromCommandLine({parseType:"varlist"});

loadDataset({
	input:input,
	command: datasetUse,
	postProcess: "library(dplyr);\n" +
		"stardata <- dplyr::select(.data=stardata, -c(" + input + "));\n" 
});
appendContent("Variable dropped.");