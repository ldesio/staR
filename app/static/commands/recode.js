
/* Parse the commandline */ //=================================================================================

// get the commandline // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

inpt = currentCommandLine.substr(currentCommandLine.indexOf(' ')).trim(); // substract the command from the string
input = parseStataSyntaxFromCommandLine({parseType:"label"});

var finalReapply = "for (v in colnames(stardata)) {expss::val_lab(stardata[,v])=expss::val_lab(stardata[,v]); };";

// IF comma, THEN 'opts' consists in the option. Otherwise this passage returns an empty 'opts' object // - - -

if (inpt.includes(',')) {
  opts = inpt.substr(inpt.indexOf(',')).trim();
  inpt = inpt.replace(opts,'');
  opts = opts.replace(',','').trim();
  
  fn = opts.substr(0, opts.indexOf('(')).trim(); // Gets the option after the comma
  newvar = opts.substr(opts.indexOf('(')+1); 
  newvar = newvar.substr(0,newvar.indexOf(')')); // These two passages get the value between parentheses

} else {
  opts = "";
  
}

// get the vrlst // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vrlst = inpt.substr(0,inpt.indexOf('(')).trim(); 
vrlst = vrlst.split(' ');

// get the expression // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

expss = inpt.substr(inpt.indexOf('(')).trim(); // get the expression after the vrlst
expss = expss.split(/\(([^)]+)\)/);
expss = expss.filter(el => {
  return el != null && el != '' && el != ' ';
	});

// get arguments of the expression: old values, new values, and labels // - - - - - - - - - - - - - - - - - - - -

n = expss.length;
args = [];
lbls = [];

for (i = 0; i < n; i++) { // THIS loop must be still implemented in order to handle wrong labels specification

/* 
IF the expressions include quotes, THEN the labels are parsed and stored in the 'lbls' object and the 
expression before the first quote is stored in the 'args' object. Otherwise the 'lbls' object is an empty 
one and the 'args' object consists in the 'expss' one. 
*/
  
  if (expss[i].includes('"')===true) {
    x = expss[i].substr(0,expss[i].indexOf('"')).trim();
    y = expss[i].substr(expss[i].indexOf('"')+1).trim();
    y = y.substr(0,y.indexOf('"')).trim();
    args.push(x);
    lbls.push(y);
  } else {
    args.push(expss[i]);
    lbls.push("");
  }
}

/*
The following loop subsets the 'args' object in order to get the values to be recoded, the new values, 
and the new labels provided. The output are three vectors of same length referring to the variable(s) 
values to be recoded ('oldvls'), the new values ('nwvls'), and the labels ('nwlbls'). These vectors are
then included in the 'vlsdf' object.
*/

oldvls = [];
nwvls = [];
nwlbls = [];

for (i = 0; i < n; i++) {
  
  x = args[i].substr(0, args[i].indexOf('=')).trim(); // gets values before the '=' operator
  y = args[i].substr(args[i].indexOf('=')+1).trim(); // gets values after the '=' operator
  y = Number(y); // string values after '=' operator are transformed into numeric ones
  z = lbls[i]; // get the ith value of the 'lbls' object

  /*
  IF the argument 'x' (namely the values before the '=' operator) includes the '/' operator, THEN the values 
  before and after '/' are used for creating a numeric (integer) vector that takes the former as the minimum 
  value and the latter as the maximum value. 
  IF 'x' does not include the '/' operator, THEN the string is split.   
  */
  
  if (args[i].includes('/')) {
    
    x = x.split('/');
    xmin = Number(x[0]);
    xmax = Number(x[1]);
    x = [];
    for(let w = xmin; w <= xmax; w += 1) {
      x.push(w);
    }

  } else if (args[i].includes('-')) {
    
    x = x.split('-');
    xmin = Number(x[0]);
    xmax = Number(x[1]);
    x = [];
    for(let w = xmin; w <= xmax; w += 1) {
      x.push(w);
    }

  } else {
    x = x.split(" ");
  }
  
  for (k = 0; k < x.length; k++) {
    oldvls.push(Number(x[k]));
    nwvls.push(y);
    nwlbls.push(z);
  }
}

vlsdf = {newvalues: nwvls, oldvalues: oldvls, labels: nwlbls};


/* Recoding */ //=============================================================================================

Rrecode = [];

/*
Recoding is conditional on the presence of the 'generate' option in the command line. 
IF the command line DOES NOT include any option AND the varlist has at least one variable, THEN for each 
var in varlist each ith old-value is substituted by the ith new-value. 
IF the command line includes a comma AND a 'generate' or 'gen' option AND the varlist has at least one 
variable AND the new variable is not in the dataset, THEN for each var in varlist each ith value of the 
original variable(s) is substituted by the ith new-value.
*/

if (vrlst.length >=1 & currentCommandLine.includes(',')===false) {
  
  for (k = 0; k < vrlst.length; k++) {
    
    for (i = 0; i < vlsdf.newvalues.length; i++) {
      
      Rrecode = (Rrecode + "stardata[[\"" + vrlst[k] + "\"]][stardata[[\"" + vrlst[k] + "\"]]==" + 
      vlsdf.oldvalues[i] + "] <- " + vlsdf.newvalues[i] +  ";\n");
       
       if (vlsdf.labels[i] === "") {
        Rrecode = (Rrecode + "labelled::val_label(stardata[[\"" + vrlst[k] + "\"]], v = " + vlsdf.newvalues[i] + ") <- NA;\n");
        } else {
          Rrecode = (Rrecode + "labelled::val_label(stardata[[\"" + vrlst[k] + "\"]], v = " + vlsdf.newvalues[i] + ") <- \"" + Encoder.htmlEncode(vlsdf.labels[i]) + "\";\n");
        }
    }
  }

  Rrecode += "\nfor (v in colnames(stardata)) {expss::val_lab(stardata[,v])=expss::val_lab(stardata[,v]); };";


  loadDataset({
  input: input,
  command: datasetUse,
  postProcess: Rrecode,
  });

} else if (vrlst.length===1 & currentCommandLine.includes(',')===true) {
  
  if (fn==="generate" | fn==="gen") {
    
    if (datasetHasVariable(newvar) === false & newvar!=="") {
      
      Rrecode = (Rrecode + "stardata[[\"" + newvar + "\"]] <- stardata[[\"" + vrlst[0] + "\"]];\n");  
      Rrecode = (Rrecode + "var_lab(stardata[[\"" + newvar + "\"]]) <- \"Recode of " + vrlst[0] + "\";\n");
      
      for (i = 0; i < vlsdf.newvalues.length; i++) {
        Rrecode = (Rrecode + "stardata[[\"" + newvar + "\"]][stardata[[\"" + newvar + "\"]]==" + 
        vlsdf.oldvalues[i] + "] <- " + vlsdf.newvalues[i] +  ";\n");
        
        if (vlsdf.labels[i] == "") {
          Rrecode = (Rrecode + "labelled::val_label(stardata[[\"" + newvar + "\"]], v = " + vlsdf.newvalues[i] + ") <- NA;\n");
          } else {
            Rrecode = (Rrecode + "labelled::val_label(stardata[[\"" + newvar + "\"]], v =  " + vlsdf.newvalues[i] + ") <- \"" + Encoder.htmlEncode(vlsdf.labels[i]) + "\";\n");
          }
      }


	Rrecode += `
# adds value labels
for (v in colnames(stardata)) {
	expss::val_lab(stardata[,v])=expss::val_lab(stardata[,v]);
}
# prepends values to value labels
for (v in colnames(stardata)) {
	expss::val_lab(stardata[[v]])= expss::prepend_values(stardata[[v]]) %>% attr(., 'labels');
}
`;

    loadDataset({
    input: input,
    command: datasetUse,
    postProcess: Rrecode,
    });
      
    } else {
      
      appendCommandDescription(input);
      appendContent("<span style='color:red'> Variable <b>" + newvar + "</b> already exists.</span>");
    }
    
  } else {
    appendCommandDescription(input);
    appendContent("<span style='color:red'> Recoding option not supported.</span>");
  }
  
} else if (vrlst.length>1 & currentCommandLine.includes(',')===true) {
  
  if (fn==="generate" | fn==="gen") {
      appendCommandDescription(currentCommandLine);
      appendContent("<span style='color:red'> Command does not support the <b> generate </b> option if varlist includes more than one variable.</span>");
  } else {
      appendCommandDescription(currentCommandLine);
      appendContent("<span style='color:red'> Recoding option not supported.</span>");
  }
}
