input = parseStataSyntaxFromCommandLine({parseType:"varlist", options:["beta"]});
  
if  (input.options.beta) {
	
	var formula = createModelFormulaFromVars(input.vars);
						
  var indepVars = input.vars.slice(1); //.shift();
  
  var commands = [
		"res <- lm(" + formula + ", data=stardata);",
		"indepvars <- all.vars(formula(res));",
		"stardata2 <- stardata;",
		"for(i in indepvars){stardata2[[i]] <- scale(stardata2[[i]])};",
		"res <- lm(" + formula + ", data=stardata2);",
		"stargazer(res,type='html',single.row=TRUE);"
	]

  runPackage({
  	title: "OLS regression of " + input.vars[0] + " by " + indepVars.join(", "),
  	input:input,
  	rPackages:["stargazer","arm"],
  	rCommands: commands
  });	
  
} else {
  
  var formula = createModelFormulaFromVars(input.vars);
						
  var indepVars = input.vars.slice(1); //.shift();
  
  var commands = [
		"res <- lm(" + formula + ", data=stardata);",
		"stargazer(res,type='html',single.row=TRUE);"
	]
  
  runPackage({
  	title: "OLS regression of " + input.vars[0] + " by " + indepVars.join(", "),
  	input:input,
  	rPackages:["stargazer"/*,"lm.beta"*/],
  	rCommands: commands
  });	
} 

