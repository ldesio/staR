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
  
  let Rsel = "";
  
  if (sel.indexOf("/") != -1) {
    // it's a range

    // remove space from slash, if range
    Rsel = sel.replace(" / ","/");
    Rsel = Rsel.replace("/ ","/");
    Rsel = Rsel.replace(" /","/");

    // convert / to %thru%
    Rsel = Rsel.replace("/"," %thru% ");

    // convert "min" and "max" to "lo" and "hi"
    Rsel = Rsel.replace("min","lo");
    Rsel = Rsel.replace("max","hi");

  } else {
    // it's separate values
    if (sel.indexOf(" ") != -1) {
      // multiple discrete values
      Rsel = "c(" + sel.replace(/ /g,",") + ")";
    } else {
      // a single value
      Rsel = sel;
    }

  }

  // in applied, what is before " " is taken as value, the rest (if any) as label
  let RdestValue = apply.split(" ")[0], RdestLabel = "";
  if (apply.indexOf(" ") > -1) RdestLabel = apply.replace(RdestValue,"") + " = ";

  // convert code for missing values
  RdestValue = RdestValue.replace(".","NA");
  
  // add new rule to be processed
  newRules.push(RdestLabel + Rsel + " ~ " + RdestValue);

}
// final default rule for copying unrecoded values
newRules.push("other ~ copy");

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
