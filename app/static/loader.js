function runCode(code) {
	
	if (code.startsWith("{\"error\"")) return false;
	
	if (Prototype.Browser.IE) {
            window.execScript(code);
        } else if (Prototype.Browser.WebKit) {
            $$("head").first().insert(Object.extend(
                new Element("script", {
                    type: "text/javascript"
                }), {
                    text: code
                }
            ));
        } else {
            window.eval(code);
        }
	return true;
}
var Script = {
    _loadedScripts: [],
    include: function(script) {
        // include script only once
        if (this._loadedScripts.include(script)) {
            return false;
        }
        // request file synchronous
        var code = new Ajax.Request(script, {
            asynchronous: false,
            method: "GET",
            evalJS: false,
            evalJSON: false,
			onFailure: function() { return false }
        }).transport.responseText;
        
		/*
		// eval code on global level
        return runCode(code);
        */
		return(code);
		
		// remember included script
        // this._loadedScripts.push(code);
    }
};