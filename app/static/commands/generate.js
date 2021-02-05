/*GC 2021-01-07 
It is identical to 'replace', what this command needs is a conditional statement in JavaScript that checks 
whether or not the 'input.newvar' does exist in the original dataset. If the var to be replaced DOES EXIST, 
then it should return an error message.*/


input = parseStataSyntaxFromCommandLine({parseType:"gen"});

loadDataset({
	input:input,
	command: datasetUse,
	postProcess: "library(dplyr);\n" +
		"stardata <- mutate(.data=stardata, " + input.newvar + " = " + input.expression +");" + 
		"var_lab(stardata$" + input.newvar + ") = '" + input.expression +"';"
});
appendContent("Variable generated successfully.");