module test;

unittest {
	import bindbc.jsl;
	import bindbc.loader.sharedlib;
	import std.conv;
	import std.stdio;
	if(loadJSL() != JSLSupport.loadedV1_1) {
		const(ErrorInfo)[] errorlist = errors;
		foreach(e; errorlist){
			writeln(to!string(e.error));
			writeln(to!string(e.message));
		}
	}
	writeln("Library loaded successfully!");

}