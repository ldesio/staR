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
    var alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
    alphabet = alphabet.map(item => `.${item}` );
    var naexists = alphabet.some(a => a == input.expression);
    
    if (ifcond.includes(".")) {
      
      x = ifcond.split(" ");
      
      for (i = 0; i < x.length; i++) {
        
        if (x[i].includes(".")) {
          
          if (x[i].includes("==")) {
            y = x[i].substr(0, x[i].indexOf("="));
            y = "is.na(" + y + ")";
          } else if (x[i].includes("!=")) {
            y = x[i].substr(0, x[i].indexOf("!"));
            y = "!is.na(" + y + ")";
          }
          
          x[i] = y;
        } 
      }
      
      ifcond = x.join(" ");
    }
    
    if (naexists === true) {
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

