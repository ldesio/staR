input = parseStataSyntaxFromCommandLine({parseType:"varlist"});

var formula = createModelFormulaFromVars(input.vars);
						
var indepVars = input.vars.slice(1); //.shift();

runPackage({
	title: "OLS regression of " + input.vars[0] + " by " + indepVars.join(", "),
	input:input,
	rPackages:["stargazer"],
	rCommands:[
		"res <- lm(" + formula + ", data=stardata);",
		"stargazer(res,type='html',single.row=TRUE);"
		]
});	


/*

BETA NOT IMPLEMENTED YET: will have to take code from old "regress.r" below...


#syntax varlist
	
	model <- model(cmd$varlist)

	
	# missing <- cmd$varlist[!(cmd$varlist %in% colnames(star.data))]
	
	
	pandoc.header(paste0("OLS Regression model of *",model$outcome, "* by ",model$pretty_predictors), 3)
	
	# Gets a data matrix of all-numeric variables, with "i." variables resolved
	# (R by default treats them as categorical)
	matrix <- resolved_data_matrix(cmd$varlist)
	
	# removes "i."
	varsyntax = resolved_model_syntax(model$syntax)

	#run OLS regression
	ols <- eval(parse(text=paste("lm(",varsyntax,",data=matrix)")))
	
	beta <- FALSE
	
	# beta option
	if (cmd$options!="") {
	  if (grepl("beta",cmd$options)) {
		
	  beta <- TRUE
	    
	  enforce_packages(c("lm.beta"))
		library(lm.beta)
		betaols <- lm.beta(ols)
		
	  stargazer(ols, betaols, 
			coef = list(ols$coefficients, 
            betaols$standardized.coefficients),
			column.labels = c("b", "beta"),
			type="html", single.row=TRUE, star.cutoffs = c(0.05, 0.01, 0.001))
	  }
	}	
	
	if(beta==FALSE) {
	  stargazer(ols, type="html", single.row=TRUE, star.cutoffs = c(0.05, 0.01, 0.001))
	}









*/