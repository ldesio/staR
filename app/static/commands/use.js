input = parseStataSyntaxFromCommandLine({parseType:"filename"});

if (!input.filename) {
	document.getElementById('file-input').click();
} else {
	// assuming URL to DTA file
	// rSyntax = "library(foreign); stardata <- read.dta('"+input.filename.replace(/\\/g,"\\\\").replace(/\"/g,"")+"')";
	rSyntax = "library(haven); library(expss); " +
		"\nstardata <- haven::read_dta('"+input.filename.replace(/\\/g,"\\\\").replace(/\"/g,"")+"')"
	
	// adds value labels
	rPostProcess =  "# adds value labels\nfor (v in colnames(stardata)) {expss::val_lab(stardata[,v])=expss::val_lab(stardata[,v]); };";
	

	loadDataset({
		input: input,
		command: rSyntax,
		postProcess: rPostProcess,
		resetPostProcess: true
	});
	
}
