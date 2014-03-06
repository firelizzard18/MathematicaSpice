

char * spice_exec(const char * cmd);

:Begin:
:Function:		spice_exec
:Pattern:		MathSpice`SpiceExec[cmd_String]
:Arguments:		{ cmd }
:ArgumentTypes: { String }
:ReturnType:	String
:End:

:Evaluate: MathSpice`SpiceExec::usage = "SpiceExec[cmd] runs the command and returns the result."