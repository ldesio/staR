input = parseStataSyntaxFromCommandLine({parseType:"varlist"});

var ivars = "";
for (i=0; i < input.vars.length; i++) {
  ivars += input.vars[i] + ",";
}

loadDataset({
	input:input,
	command: datasetUse,
	postProcess: "stardata <- dplyr::select(.data=stardata, -c(" + ivars + "));\n"
});
