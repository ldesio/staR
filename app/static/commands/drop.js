input = parseStataSyntaxFromCommandLine({parseType:"drop"});

loadDataset({
	input:input,
	command: datasetUse,
	postProcess: "library(dplyr);\n" +
		"stardata <- dplyr::select(.data=stardata, -c(" + input.newvar + "));\n" 
});
appendContent("Variable dropped.");