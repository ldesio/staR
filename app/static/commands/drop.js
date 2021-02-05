input = parseStataSyntaxFromCommandLine({parseType:"varlist"});

var varlist = "";
for (i=0; i < input.vars.length; i++) {
    varlist += input.vars[i] + ",";
}

loadDataset({
	input:input,
	command: datasetUse,
	postProcess: "stardata <- dplyr::select(.data=stardata, -c(" + varlist + "));\n"
});
