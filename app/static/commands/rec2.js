var line = currentCommandLine;

var beforeComma = line.split(",")[0];

// find rules: convert content in parentheses into array of rules
var rules = beforeComma.match(/\(.*?\)/g);
rules = rules.map(function(match) { return match.slice(1, -1); })

var newRules = [];

// original command line, from which we'll remove rules to obtain clean line
var cleanedLine = line;

for (var i = 0; i < rules.length; i++) {

  let el = rules[i];

  // removes rule from command line, so command line later can be parsed as varlist with options
  line = line.replace("(" + el + ")","");

  // split rule into selection (left) and applied value (right)
  let sel = el.split("=")[0].trim(), apply = el.split("=")[1].trim();
  
  // remove space from slash, if range
  sel = sel.replace(" / ","/");

  // coverting to expss::recode syntax: replace space with : for multiple specific values
  let Rsel = sel.replace(/ /g,":");

  // convert / to %thru%
  Rsel = Rsel.replace("/"," %thru% ");

  // convert "min" and "max" to "lo" and "hi"
  Rsel = Rsel.replace("min","lo");
  Rsel = Rsel.replace("max","hi");
  
  // in applied, what is before " " is taken as value, the rest (if any) as label
  let RdestValue = apply.split(" ")[0], RdestLabel = "";
  if (apply.indexOf(" ") > -1) RdestLabel = apply.replace(RdestValue,"") + " = ";

  // convert code for missing values
  RdestValue = RdestValue.replace(".","NA");
  
  // add new rule to be processed
  newRules.push(RdestLabel + Rsel + " ~ " + RdestValue);

}

// in fact this is parsing the original line (not the cleaned one), but it works.
// No time to test that removing the "cleaned line" code is harmless...
input2 = parseStataSyntax(line,"varlist",["generate"]);

var sourceVar = input2.vars[0]
var destVar  = sourceVar; // defaults to replacing existing variable
if (input2.options.generate) destVar = input2.options.generate;


finalRecode = "library(expss); stardata$" + destVar + " <- recode(stardata$" + sourceVar + ", " + newRules.join(",") + ");";

// this does not work...
finalRecode += "expss::val_lab(stardata$" + destVar + ")=expss::val_lab(stardata$" + destVar + ");";

loadDataset({
  input: input,
  command: datasetUse,
  postProcess: finalRecode,
});
