input = parseStataSyntaxFromCommandLine({parseType:"varlist", options:["nofreq", "row", "column", "cell", "missing"]});

var freWeight = "", weightDesc = "";
if (input.weight) {
	freWeight = ", weight=stardata$" + input.weight.split("=")[1];
	weightDesc = ";<br>[data weighted by <i>" + input.weight.split("=")[1] + "</i>]";
}


rCommands = [
	"cat(\"<h3>Cross-tabulation of " + input.vars[0] + " by " + input.vars[1] + weightDesc + "</h3>\");"
	]

	var _droprc = "drop_rc";
	if (input.options.missing) _droprc = "";

	if (!input.options.nofreq) {
		rCommands.push("cat(\"<h4>Absolute frequencies</h4>\")");
		rCommands.push("cat(knit_print(" + _droprc + "(cro(stardata$" + input.vars[0] + freWeight + ", list(stardata$" + input.vars[1] + ",total()),total_label=\"N\")))[1]);");
	}
	if (input.options.row) {
		rCommands.push("cat(\"<h4>Row percentages</h4>\")");
		rCommands.push("cat(knit_print(" + _droprc + "(cro_rpct(list(stardata$" + input.vars[0] + freWeight + ",total()), list(stardata$" + input.vars[1] + ",total()),total_label=\"N\",total_row_position=\"none\")))[1]);"); 
	}
	if (input.options.column) {
		rCommands.push("cat(\"<h4>Column percentages</h4>\")");
		rCommands.push("cat(knit_print(" + _droprc + "(cro_cpct(list(stardata$" + input.vars[0] + freWeight + ",total()), list(stardata$" + input.vars[1] + ",total()),total_label=\"N\",total_row_position=\"none\")))[1]);"); 
	}
	if (input.options.cell) {
		rCommands.push("cat(\"<h4>Cell percentages</h4>\")");
		rCommands.push("cat(knit_print(" + _droprc + "(cro_tpct(list(stardata$" + input.vars[0] + freWeight + ",total()), list(stardata$" + input.vars[1] + ",total()),total_label=\"N\",total_row_position=\"none\")))[1]);"); 
	}

runPackage({
	input: input,
	rPackages: ["knitr","expss"],
	rCommands: rCommands
});