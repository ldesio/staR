input = parseStataSyntaxFromCommandLine({parseType:"varlist"});

var formula = createModelFormulaFromVars(input.vars);
						
var indepVars = input.vars.slice(1); //.shift();

var commands = [
		"res <- glm(" + formula + ", family = \"binomial\", data=stardata);",
		"stargazer(res,type='html',single.row=TRUE);"
	]
/*
if  (input.options.beta) {
	commands = [

	]
}
*/


runPackage({
	title: "Logit regression of " + input.vars[0] + " by " + indepVars.join(", "),
	input:input,
	rPackages:["stargazer"/*,"lm.beta"*/],
	rCommands: commands
});	
