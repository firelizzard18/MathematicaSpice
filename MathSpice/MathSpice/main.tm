:Evaluate:		MathSpice`SpiceExec::usage = "SpiceExec[cmd] runs the command and returns the result."
:Begin:
:Function:		spice_exec
:Pattern:		MathSpice`SpiceExec[cmd_String]
:Arguments:		{ cmd }
:ArgumentTypes: { Manual }
:ReturnType:	Manual
:End:

:Evaluate:		MathSpice`SpiceSource::usage = "SpiceSource[file] sources the file."
:Begin:
:Function:		spice_source
:Pattern:		MathSpice`SpiceSource[file_String]
:Arguments:		{ file }
:ArgumentTypes: { Manual }
:ReturnType:	Manual
:End:

:Evaluate:		MathSpice`SpiceData::usage = "SpiceData[] retreives the current set of data."
:Begin:
:Function:		spice_data
:Pattern:		MathSpice`SpiceData[]
:Arguments:		{ }
:ArgumentTypes: { }
:ReturnType:	Manual
:End:

:Evaluate:		MathSpice`SpiceTransient::usage = "SpiceTransient[step, stop] calculates the transient response of the ciruit and returns the data."
:Evaluate:		Options[MathSpice`SpiceTransient] = {MathSpice`TransientStartTime -> Null, MathSpice`TransientMaxStep -> Null, MathSpice`TransientUseInitialConditions -> False}
:Evaluate:		MathSpice`SpiceTransient::badTP1 = "Parameter step must be a number or null"
:Evaluate:		MathSpice`SpiceTransient::badTP2 = "Parameter stop must be a number or null"
:Evaluate:		MathSpice`SpiceTransient::badTPU = "Unexpected parameter `1`"
:Evaluate:		MathSpice`SpiceTransient::badTST = "Option TransientStartTime must be a number or null"
:Evaluate:		MathSpice`SpiceTransient::badTMS = "Option TransientMaxStep must be a number or null"
:Evaluate:		MathSpice`SpiceTransient::badTUIC = "Option TransientUseInitialConditions must be True or False"
:Evaluate:		MathSpice`SpiceTransient::TMSwoTST = "Value of option TransientMaxStep will be ignored as option TransientStartTime was not set"
:Begin:
:Function:		spice_tran
:Pattern:		MathSpice`SpiceTransient[step_, stop_, opts___]
:Arguments:		{ step, stop, opts }
:ArgumentTypes: { Manual }
:ReturnType:	Manual
:End:

:Evaluate:		MathSpice`SpiceAC::usage = "SpiceAC[start, stop] calculates the AC small-signal response of the ciruit and returns the data."
:Evaluate:		MathSpice`ACModeDecade = "dec"
:Evaluate:		MathSpice`ACModeOctave = "oct"
:Evaluate:		MathSpice`ACModeLinear = "lin"
:Evaluate:		Options[MathSpice`SpiceAC] = {MathSpice`ACMode -> MathSpice`ACModeDecade, MathSpice`ACPointsPerDecade -> 100, MathSpice`ACPointsPerOctave -> 100, MathSpice`ACLinearPoints -> 100}
:Evaluate:		MathSpice`SpiceAC::badParam1 = "Parameter start must be a number or null"
:Evaluate:		MathSpice`SpiceAC::badParam2 = "Parameter stop must be a number or null"
:Evaluate:		MathSpice`SpiceAC::badParamU = "Unexpected parameter `1`"
:Evaluate:		MathSpice`SpiceAC::badOptMode = "Option ACMode must be \"dec\", \"oct\", or \"lin\""
:Evaluate:		MathSpice`SpiceAC::badOptDec = "Option ACPointsPerDecade must be a number"
:Evaluate:		MathSpice`SpiceAC::badOptOct = "Option ACPointsPerOctave must be a number"
:Evaluate:		MathSpice`SpiceAC::badOptLin = "Option ACLinearPoints must be a number"
:Begin:
:Function:		spice_ac
:Pattern:		MathSpice`SpiceAC[start_, stop_, opts___]
:Arguments:		{ start, stop, opts }
:ArgumentTypes: { Manual }
:ReturnType:	Manual
:End:

:Evaluate:		MathSpice`Error::spice = "`1`"
:Evaluate:		MathSpice`Warn::spice = "`1`"
:Evaluate:		MathSpice`Error::mlink = "There has been a MathLink error: `1`"