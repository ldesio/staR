input = parseStataSyntaxFromCommandLine({parseType:"varlist", options:["jitter"]});

var theseVars = "nolabeled$" + input.vars[1] + ", nolabeled$" + input.vars[0];
if (input.options.jitter) theseVars = "jitter(nolabeled$" + input.vars[1] + "), jitter(nolabeled$" + input.vars[0] +")";


runPackage({
	title: "Scatterplot of " + input.vars[0] + " by " + input.vars[1],
	input:input,
	rCommands: [
		"nolabeled <- data.frame(data.matrix(stardata));",
		wrapGraphicCommand(
			"plot(" + theseVars + ", xlab='" + Encoder.htmlEncode(varLabel(input.vars[1]))+"', ylab='" + Encoder.htmlEncode(varLabel(input.vars[0]))+"');"
		)
	]
})
