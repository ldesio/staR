console.log(currentCommandLine);

var helpCommand = currentCommandLine.trim().split(" ")[1];


var helpScriptName = getScriptName(helpCommand);
var helpCode = Script.include("commands/" + helpScriptName + ".js");

if (helpCode.includes("{\"error\":[\"404 - Resource Not Found\"]}")) {
	reportError(
		{commandline:currentCommandLine},
		"Command <b>" + helpCommand + "</b> is unrecognized or not implemented in staR."
	);					
} else {
	var URL = "help.html?command=" + helpScriptName;

	appendCommandDescription(currentCommandLine,"");

	if (helpwindow) helpwindow.close();
	helpwindow = window.open(URL,"helpwindow");


}


