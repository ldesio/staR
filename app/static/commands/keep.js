// NOW THIS IMPLEMENTS BOTH KEEP AND DROP
// (drop.js calls this file; input.command allows to detect which command was called)


input = parseStataSyntaxFromCommandLine({parseType:"varlist"});

console.log(input.command);

// this subsets variables
if (input.if =="") {
  
  var ivars = "";
  for (i=0; i < input.vars.length; i++) {
    ivars += input.vars[i] + ",";
  }
 
  // default for "keep"
  let subsetCond = "c(" + ivars + ")";
  // if instead "drop", reverses condition
  if (input.command=="drop") subsetCond = "-" + subsetCond;

  rSubset = "stardata <- dplyr::select(.data=stardata, " + subsetCond + ");\n";
  
}
// this instead subsets cases. The two forms are alternative.
else if (input.if !="") {

/*
	LDS 4.1.2021:
	IMPORTANT:
		when calling "loadDataset()"
		(used when altering the data, while "runPackage()" is instead used for regular comands)
		auto-IF and auto-BY are not performed (and not available).
		So there is no need to bypass them.
*/

  // default for "keep"
  let subsetCond = input.if;

  // if instead "drop", reverses condition
  if (input.command=="drop") subsetCond = "!(" + subsetCond + ")";


	rSubset = "library(labelled)\n" + 
		"ifss <- base::subset(remove_labels(stardata)," + subsetCond + ");\n" +
		"ifss <- copy_labels(stardata,ifss);\n" + 
		"for (v in colnames(ifss)) {expss::val_lab(ifss[,v])=expss::val_lab(ifss[,v]); };\n" + 
		"stardata <- ifss;\n";

}

loadDataset({
	input:input,
	command: datasetUse,
	postProcess: rSubset
});