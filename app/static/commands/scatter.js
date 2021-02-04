input = parseStataSyntaxFromCommandLine({parseType:"varlist"});
runPackage({
	title: "Scatterplot of " + input.vars[0] + " by " + input.vars[1],
	input:input,
	rCommands: [
		"nolabeled <- data.frame(data.matrix(stardata));",
		wrapGraphicCommand(
			"plot(nolabeled$" + input.vars[1] + 
			",nolabeled$" + input.vars[0] + 
			", xlab='" + varLabel(input.vars[1])+"', ylab='" + varLabel(input.vars[0])+"');"
		)
	]
})
