module test;

unittest {
	import bindbc.jsl;
	import bindbc.loader.sharedlib;
	import std.conv;
	import std.stdio;
	JSLSupport vers = loadJSL();
	if(vers == JSLSupport.noLibrary || vers == JSLSupport.badLibrary) {
		const(ErrorInfo)[] errorlist = errors;
		foreach(e; errorlist){
			writeln(to!string(e.error));
			writeln(to!string(e.message));
		}
	} else {
		writeln("Library loaded successfully!");
		writeln("Loaded version: ", vers);
	}

}