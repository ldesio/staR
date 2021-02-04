// console.log(input.commandline); // input.commandline is always available
input = parseStataSyntaxFromCommandLine({parseType:"varlist", options:["nolabel"]});

rCommands = [];

var noLabel = false;
if  (input.options.nolabel) noLabel = true;

rCommands.push("options(huxtable.knitr_output_format = \"html\")");

for (i=0; i < input.vars.length; i++) {
	let name = input.vars[i], label = varLabel(input.vars[i]);

	rCommands.push(
		"cat(paste0('<h3>Frequency distribution of " + name + " (<i>" + label + "</i>)</h3>'))");
	if (noLabel) rCommands.push("val_lab(stardata$"+name+")=NULL");

	rCommands.push("cat(knit_print(fre(stardata$" + name + ")))");
	if (i<input.vars.length-1) rCommands.push("\"<br/>\"");
}

console.log(rCommands);

runPackage({
	input: input,
	rPackages: ["knitr","expss"],
	rCommands: rCommands,
});
