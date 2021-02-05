
/* Parse the commandline */ //=================================================================================

// get the commandline // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

inpt = currentCommandLine.substr(currentCommandLine.indexOf(' ')).trim(); // substract the command from the string
input = currentCommandLine; 

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

// get arguments of the expression: old values, new values, and labels // - - - - - - - - - - - - - - - - - - -

n = expss.length;
args = [];
lbls = [];

for (i = 0; i < n; i++) { // THIS loop must be still implemented in order to handle wrong labels specification
  
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

nwvls = [];
oldvls = [];
nwlbls = [];

for (i = 0; i < n; i++) {
  
  if (args[i].includes('/')===false) {
    
  x = args[i].substr(0, args[0].indexOf('=')).trim();
  x = x.split(" ");
  nn = x.length;
  y = args[i].substr(args[0].indexOf('=')+2).trim();
  y = Number(y);
  z = lbls[i];
  
  } else {
    
    x = args[i].substr(0, args[0].indexOf('=')).trim();
    x = x.split('/');
    xmin = Number(x[0]);
    xmax = Number(x[1]);
    x = [];
    for(let w = xmin; w <= xmax; w += 1) {
      x.push(w);
    }
    nn = x.length;
    y = args[i].substr(args[0].indexOf('=')+2).trim();
    y = Number(y);
    z = lbls[i];
  }
  
  for (k = 0; k < nn; k++) {
    oldvls.push(Number(x[k]));
    nwvls.push(y);
    nwlbls.push(z);
  }
}

vlsdf = {newvalues: nwvls, oldvalues: oldvls, labels: nwlbls};


/* Recoding */ //=============================================================================================

Rrecode = [];

if (vrlst.length >=1 & input.includes(',')===false) {
  
  for (k = 0; k < vrlst.length; k++) {
    
    for (i = 0; i < vlsdf.newvalues.length; i++) {
      
      Rrecode = (Rrecode + "stardata[[\"" + vrlst[k] + "\"]][stardata[[\"" + vrlst[k] + "\"]]==" + 
      vlsdf.oldvalues[i] + "] <- " + vlsdf.newvalues[i] +  ";");
    }

    /* GC 20201-01-15: values are not being labeled.... why?*/
    for (i = 0; i < vlsdf.newvalues.length; i++) { // This loop is actually too long for the purpose, but fine for no
      if (vlsdf.labels[i] === "") {
        Rrecode = (Rrecode + "labelled::val_label(stardata[[\"" + vrlst[k] + "\"]], " + vlsdf.newvalues[i] + ") <- NA;");
        } else {
          Rrecode = (Rrecode + "labelled::val_label(stardata[[\"" + vrlst[k] + "\"]], " + vlsdf.newvalues[i] + ") <- \"" + vlsdf.labels[i] + "\";");
        }
      }
  }

  loadDataset({
  input: appendCommandDescription,
  command: datasetUse,
  postProcess: Rrecode,
  });

} else if (vrlst.length===1 & input.includes(',')===true) {
  
  if (fn==="generate" | fn==="gen") {
    
    if (datasetHasVariable(newvar) === false & newvar!=="") {
      
      Rrecode = (Rrecode + "stardata[[\"" + newvar + "\"]] <- stardata[[\"" + vrlst[0] + "\"]];");  
      Rrecode = (Rrecode + "var_lab(stardata[[\"" + newvar + "\"]]) <- \"Recode of " + vrlst[0] + "\";");
      
      for (i = 0; i < vlsdf.newvalues.length; i++) {
        Rrecode = (Rrecode + "stardata[[\"" + newvar + "\"]][stardata[[\"" + newvar + "\"]]==" + 
        vlsdf.oldvalues[i] + "] <- " + vlsdf.newvalues[i] +  ";");
      }
    
      for (i = 0; i < vlsdf.newvalues.length; i++) { // This loop is actually too long for the purpose, but fine for now
    
        if (vlsdf.labels[i] == "") {
          Rrecode = (Rrecode + "labelled::val_label(stardata[[\"" + newvar + "\"]], " + vlsdf.newvalues[i] + ") <- NA;");
          } else {
            Rrecode = (Rrecode + "labelled::val_label(stardata[[\"" + newvar + "\"]], " + vlsdf.newvalues[i] + ") <- \"" + vlsdf.labels[i] + "\";");
          }
      }
    
    loadDataset({
    input: appendCommandDescription,
    command: datasetUse,
    postProcess: Rrecode,
    });
      
    } else {
      
      appendCommandDescription(input);
      appendContent("<span style='color:red'> Variable <b>" + newvar + "</b> already exists.</span>");
    }
    
  } else {
    appendCommandDescription(input);
    appendContent("<span style='color:red'> Recoding option not supported.");
  }
}
