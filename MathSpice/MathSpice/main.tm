:Evaluate:		MathSpice`SpiceExec::usage = "SpiceExec[cmd] runs the command and returns the result."
:Begin:
:Function:		spice_exec
:Pattern:		MathSpice`SpiceExec[cmd_String]
:Arguments:		{ cmd }
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
:Evaluate:		MathSpice`SpiceTransient::badTST = "Option TransientStartTime must be a number or null"
:Evaluate:		MathSpice`SpiceTransient::badTMS = "Option TransientMaxStep must be a number or null"
:Evaluate:		MathSpice`SpiceTransient::badTUIC = "Option TransientUseInitialConditions must be True or False"
:Evaluate:		MathSpice`SpiceTransient::TMSwoTST = "Value of option TransientMaxStep will be ignored as option TransientStartTime was not set"
:Begin:
:Function:		spice_tran
:Pattern:		MathSpice`SpiceTransient[step_Real, stop_Real, OptionsPattern[{MathSpice`TransientStartTime -> Null, MathSpice`TransientMaxStep -> Null, MathSpice`TransientUseInitialConditions -> False}]]
:Arguments:		{ step, stop }
:ArgumentTypes: { Manual }
:ReturnType:	Manual
:End:

:Evaluate:		MathSpice`Error::spice = "`1`"
:Evaluate:		MathSpice`Warn::spice = "`1`"
:Evaluate:		MathSpice`Error::mlink = "There has been a MathLink error: `1`"