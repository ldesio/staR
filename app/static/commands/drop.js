input = parseStataSyntaxFromCommandLine({parseType:"varlist"});


for (i=0; i < input.vars.length; i++) {
  
    loadDataset({
	input:input,
	command: datasetUse,
	postProcess: "stardata <- dplyr::select(.data=stardata, -c(" + input.vars[i] + "));\n" 
  });


  /*rCommands.push("stardata <- dplyr::select(.data=stardata, -c(" + input.vars[i] + "));\n" )*/
  
}

