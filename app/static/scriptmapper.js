function getScriptName(command) {
	var script = command;
	if (command == "reg") script = "regress";
	if (command == "hist") script = "histogram";
	if (command == "gen") script = "generate";

	return script;
}