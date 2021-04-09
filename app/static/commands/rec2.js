var line = currentCommandLine;

// very rough, but...
var destVar = line.split(" ")[1];
var beforeComma = line.split(",")[0];

// split by parentheses into array of rules
var rules = beforeComma.match(/\(.*?\)/g);
rules = rules.map(function(match) { return match.slice(1, -1); })

var newRules = [];

for (var i = 0; i < rules.length; i++) {
  let el = rules[i];
  // split rule into selection (left) and applied value (right)
  let sel = el.split("=")[0], apply = el.split("=")[1];
  
  // remove space from slash, if range
  sel = sel.replace(" / ","/");

  // coverting to expss::recode syntax: replace space with : for multiple specific values
  let Rsel = sel.replace(/ /g,":");

  // convert / to %thru%
  Rsel = Rsel.replace("/"," %thru% ");
  
  // in applied, what is before " " is taken as value, the rest (if any) as label
  let RdestValue = apply.split(" ")[0], RdestLabel = "";
  if (apply.indexOf(" ") > -1) RdestLabel = apply.replace(RdestValue,"") + " = ";

  RdestValue = RdestValue.replace(".","NA");
  
  newRules.push(RdestLabel + Rsel + " ~ " + RdestValue);

}

finalRecode = "stardata$" + destVar + " <- recode(stardata$" + destVar + ", " + newRules.join(",") + ");";

// this does not work...
finalRecode += "for (v in colnames(stardata)) {expss::val_lab(stardata[,v])=expss::val_lab(stardata[,v]); };";

console.log(finalRecode);

loadDataset({
  input: input,
  command: datasetUse,
  postProcess: finalRecode,
});
