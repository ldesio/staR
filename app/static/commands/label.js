var input = parseStataSyntaxFromCommandLine({parseType:"label"});
var inpt = currentCommandLine.match(/\w+|"[^"]+"/g);

inpt.command = [];

inpt.command[0] = inpt[0];
inpt.command[1] = inpt[1];
inpt.var = inpt[2];
inpt.label = inpt[3];


var chk0 = inpt.length===4;
var cond1 = ["var" , "variable" , "val" , "values" , "def" , "define" , "lang" , "language" , "l" , "list" , "da" , "data" , "drop" , "save" , "dir"];
var chk1 = cond1.some(el => inpt.command[1].includes(el));
var chk2 = inpt.label.includes('"');
var chk3 = datasetHasVariable(inpt.var);


if (chk0) {
  if (chk1 && chk2 && chk3) {
    if (inpt.command[1] === "var" | inpt.command[1] === "variable") {
      
      loadDataset({
      input: input,
      command: datasetUse,
      postProcess: "library(labelled);\n" +
      "var_label(x = stardata[[\"" + inpt.var + "\"]]) <- " + inpt.label + ";"
      });
      
    } else {
       appendCommandDescription(input.expression);
       appendContent("<span style='color:red'> Command <b> label " + inpt.command[1] + "</b> is not supported.</span>");
    }
  } else {
    appendCommandDescription(input.expression);
    appendContent("<span style='color:red'> Invalid syntax.</span>");
  }
} else {
  appendCommandDescription(input.expression);
  appendContent("<span style='color:red'> Invalid syntax.</span>");
}

