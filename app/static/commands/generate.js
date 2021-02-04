input = parseStataSyntaxFromCommandLine({parseType:"gen"});

loadDataset({
	input:input,
	command: datasetUse,
	postProcess: "library(dplyr);\n" +
		"stardata <- mutate(.data=stardata, " + input.newvar + " = " + input.expression +");" + 
		"var_lab(stardata$" + input.newvar + ") = '" + input.expression +"';"
});
appendContent("Variable generated successfully.");