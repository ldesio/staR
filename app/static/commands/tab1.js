// console.log(input.commandline); // input.commandline is always available
input = parseStataSyntaxFromCommandLine({parseType:"varlist", options:["nolabel"]});

rCommands = [];

var noLabel = false;
if  (input.options.nolabel) noLabel = true;

rCommands.push("options(huxtable.knitr_output_format = \"html\")");

console.log(input.weight);
var freWeight = "", weightDesc = "";
if (input.weight) {
	freWeight = ", weight=stardata$" + input.weight.split("=")[1];
	weightDesc = ";<br>[data weighted by <i>" + input.weight.split("=")[1] + "</i>]";
}

for (i=0; i < input.vars.length; i++) {
	let name = input.vars[i], label = varLabel(input.vars[i]);
	label = Encoder.htmlEncode(label);
	
	rCommands.push(
		"cat(paste0('<h3>Frequency distribution of " + name + " (<i>" + label + "</i>)"+weightDesc+"</h3>'))");
	if (noLabel) rCommands.push("val_lab(stardata$"+name+")=NULL");

	rCommands.push("cat(knit_print(fre(stardata$" + name + freWeight + ")))");
	if (i<input.vars.length-1) rCommands.push("\"<br/>\"");
}

console.log(rCommands);

runPackage({
	input: input,
	rPackages: ["knitr","expss"],
	rCommands: rCommands,
});
