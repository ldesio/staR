input = parseStataSyntaxFromCommandLine({parseType:"varlist"});
runPackage({
	title: "Histogram of " + input.vars[0],
	input: input,
	rCommands: [
		wrapGraphicCommand(
			"barplot(prop.table(table(stardata[,'" + input.vars[0] + "'])))"
		)
	]
});
