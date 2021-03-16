input = parseStataSyntaxFromCommandLine({parseType:"filename"});

if (!input.filename) {
	document.getElementById('file-input').click();
} else {
	// assuming URL to DTA file
	
// attempts first to read as UTF-8 (supports accented letters), otherwise falls back to default encoding
rSyntax = `
tryCatch(
	{
		stardata <- haven::read_dta('${input.filename.replace(/\\/g,"\\\\").replace(/\"/g,"")}', encoding='utf-8')
	}, error = function(e) {
		stardata <- haven::read_dta('${input.filename.replace(/\\/g,"\\\\").replace(/\"/g,"")}')
	}
)`;

	// adds value labels
	rPostProcess =  `
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
		command: rSyntax,
		postProcess: rPostProcess,
		resetPostProcess: true
	});
	
}
