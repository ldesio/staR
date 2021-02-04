input = parseStataSyntaxFromCommandLine({parseType:"varlist", options:["nofreq", "row", "column", "cell"]});

rCommands = [
	"cat(\"<h3>Cross-tabulation of " + input.vars[0] + " by " + input.vars[1] + "</h3>\");"
	]

	if (!input.options.nofreq) {
		rCommands.push("cat(\"<h4>Absolute frequencies</h4>\")");
		rCommands.push("cat(knit_print(cro(stardata$" + input.vars[0] + ", stardata$" + input.vars[1] + ",total_label=\"N\"))[1]);");
	}
	if (input.options.row) {
		rCommands.push("cat(\"<h4>Row percentages</h4>\")");
		rCommands.push("cat(knit_print(cro_rpct(stardata$" + input.vars[0] + ", list(stardata$" + input.vars[1] + ",total()),total_label=\"N\",total_row_position=\"none\"))[1]);"); 
	}
	if (input.options.column) {
		rCommands.push("cat(\"<h4>Column percentages</h4>\")");
		rCommands.push("cat(knit_print(cro_cpct(list(stardata$" + input.vars[0] + ",total()), stardata$" + input.vars[1] + ",total_label=\"N\",total_row_position=\"none\"))[1]);"); 
	}
	if (input.options.cell) {
		rCommands.push("cat(\"<h4>Cell percentages</h4>\")");
		rCommands.push("cat(knit_print(cro_tpct(list(stardata$" + input.vars[0] + ",total()), list(stardata$" + input.vars[1] + ",total()),total_label=\"N\",total_row_position=\"none\"))[1]);"); 
	}

runPackage({
	input: input,
	rPackages: ["knitr","expss"],
	rCommands: rCommands
});