if (currentCommandLine.includes("if")===false) {

  input = parseStataSyntaxFromCommandLine({parseType:"gen"});
  
  if (datasetHasVariable(input.newvar) === true) {
    
  loadDataset({
  	input:input,
  	command: datasetUse,
  	postProcess: "library(dplyr);\n" +
  		"stardata <- mutate(.data=stardata, " + input.newvar + " = " + input.expression +");" + 
  		"var_lab(stardata$" + input.newvar + ") = '" + input.expression +"';"
  });
  
  appendContent("Variable replaced successfully.");
    
  } else {
    /* 
    GC 2021-01-08 I tried existing funs to report the error but I have not been able to 
    use those in this passage, thus I just created an ad hoc one.
    */
    appendCommandDescription(input.commandline);
    appendContent("<span style='color:red'> Variable <b>" + input.newvar + "</b> does not exist.</span>");
  }
  
} else {
  
  input = parseStataSyntaxFromCommandLine({parseType:"gen"});
  
  if (datasetHasVariable(input.newvar) === true) {
    
    var ifcond = currentCommandLine.substr(currentCommandLine.indexOf('if')+2).trim();
    
    loadDataset({
    	input:input,
    	command: datasetUse,
    	postProcess: "library(dplyr);\n" +
    	  "stardata2 <- subset(x=stardata, c(" + ifcond + "));" +
    		"stardata2 <- mutate(.data=stardata2, " + input.newvar + " = " + input.expression +");" + 
    		"stardata <- dplyr::select(.data=stardata, -c(" + input.newvar + "));" +
    		"stardata <- left_join(stardata, stardata2);" +
    		"rm(stardata2);" +
    		"var_lab(stardata$" + input.newvar + ") = '" + input.expression + " (" + ifcond + ")';"
    });  
    
    appendContent("Variable replaced successfully.");
    
  } else {
    /* 
    GC 2021-01-08 I tried existing funs to report the error but I have not been able to 
    use those in this passage, thus I just created an ad hoc one.
    */
    appendCommandDescription(input.commandline);
    appendContent("<span style='color:red'> Variable <b>" + input.newvar + "</b> does not exist.</span>");
  }
}