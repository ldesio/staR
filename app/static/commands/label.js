var input = currentCommandLine.match(/\w+|"[^"]+"/g);

loadDataset({
input:currentCommandLine,
command: datasetUse,
postProcess: "library(labelled);\n" +
"var_label(x = stardata[[\"" + input[2] + "\"]]) <- " + input[3] + ";"
});
