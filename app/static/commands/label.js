var input = currentCommandLine.match(/\w+|"[^"]+"/g);

input.command = [];

input.command[0] = input[0];
input.command[1] = input[1];
input.var = input[2];
input.label = input[3];


if (input.command[1] === "var" | input.command[1] === "variable") {
  
  loadDataset({
  input:currentCommandLine,
  command: datasetUse,
  postProcess: "library(labelled);\n" +
  "var_label(x = stardata[[\"" + input.var + "\"]]) <- " + input.label + ";"
  });
  
  
} else if (input.command[1] === "val" | input.command[1] === "values") {
  
  appendCommandDescription(currentCommandLine);
  appendContent("<span style='color:red'> Command <b> label values </b> is not implemented.</span>");
  
} else if (input.command[1] === "def" | input.command[1] === "define") {
  
  appendCommandDescription(currentCommandLine);
  appendContent("<span style='color:red'> Command <b> label define </b> is not implemented.</span>");
  
} else if (input.command[1] === "l" | input.command[1] === "list") {

  appendCommandDescription(currentCommandLine);
  appendContent("<span style='color:red'> Command <b> label list </b> is not implemented.</span>");

} else if (input.command[1] === "da" | input.command[1] === "data") {

  appendCommandDescription(currentCommandLine);
  appendContent("<span style='color:red'> Command <b> label data </b> is not implemented.</span>");
  
} else if (input.command[1] === "drop" | input.command[1] === "save" | input.command[1] === "dir") {

  appendCommandDescription(currentCommandLine);
  appendContent("<span style='color:red'> Command <b> label " + input.command[1] + "</b> is not implemented.</span>");
  
}


