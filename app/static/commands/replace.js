input = parseStataSyntaxFromCommandLine({parseType:"gen"});

if (currentCommandLine.includes("if")===false) {

  if (datasetHasVariable(input.newvar) === true) {
    
  loadDataset({
  	input:input,
  	command: datasetUse,
  	postProcess: "library(dplyr);\n" +
  		"stardata <- mutate(.data=stardata, " + input.newvar + " = " + input.expression +");" + 
  		"labelled::var_label(stardata$" + input.newvar + ") = '" + input.expression +"';"
  });
    
  } else {
    /* 
    GC 2021-01-08 I tried existing funs to report the error but I have not been able to 
    use those in this passage, thus I just created an ad hoc one.
    */
    appendCommandDescription(input.commandline);
    appendContent("<span style='color:red'> Variable <b>" + input.newvar + "</b> does not exist.</span>");
  }
  
} else {
  
  if (datasetHasVariable(input.newvar) === true) {
    
    var ifcond = currentCommandLine.substr(currentCommandLine.indexOf('if')+2).trim();
    
    if (input.expression === ".") {
      
      input.expression = "NA";

    }
    
    loadDataset({
    	input:input,
    	command: datasetUse,
    	postProcess: "library(magrittr);\n" +
        input.newvar + "<- stardata$" + input.newvar + " %>% unlist() %>% as.numeric();" +
        input.newvar + "[" + ifcond + "] <- " + input.expression + ";" +
        "stardata$" + input.newvar + " <- " + input.newvar + ";"
    });  
    
  } else {
    /* 
    GC 2021-01-08 I tried existing funs to report the error but I have not been able to 
    use those in this passage, thus I just created an ad hoc one.
    */
    appendCommandDescription(input.commandline);
    appendContent("<span style='color:red'> Variable <b>" + input.newvar + "</b> does not exist.</span>");
  }
}