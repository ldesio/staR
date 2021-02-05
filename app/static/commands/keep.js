/*
	Codice da testare (LDS)
	Potrebbe funzionare, ma bisogna trovare il modo di bypassare la gestione standard di "if"...
*/

input = parseStataSyntax({parseType:"varlist"});

/*
if (input.if !="") {

	rSubset = "library(labelled)\n" + 
		"tmp <- base::subset(remove_labels(stardata)," + input.if + ");\n" +
		"tmp <- copy_labels(stardata,ifss);\n" + 
		"for (v in colnames(tmp)) {expss::val_lab(tmp[,v])=expss::val_lab(tmp[,v]); };\n" + 
		"stardata <- tmp;\n";

	loadDataset({
		input:input,
		command: datasetUse,
		postProcess: rSubset
	});
}
*/

if (input.if !="") {
  
  var ivars = "";
  for (i=0; i < input.vars.length; i++) {
    ivars += input.vars[i] + ",";
  }
  
  loadDataset({
  	input:input,
  	command: datasetUse,
  	postProcess: "stardata <- dplyr::select(.data=stardata, c(" + ivars + "));\n"
  });
  
}