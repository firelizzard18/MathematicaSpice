(* ::Package:: *)

BeginPackage["MathSpice`"];

SpiceHelp::usage="SpiceHelp[] prints usage information for various MathSpice functions";
SpiceConnect::usage="SpiceConnect[] links the MathSpice executable";
SpiceDisconnect::usage="SpiceDisconnect[] unlinks the MathSpice executable";

SpiceTransientAnalysis::usage="SpiceTransientAnalysis[file, step, stop] links MathSpice, sources the file, performs a transient analysis, saves the data, unlinks MathSpice, and returns the data";
SpiceACAnalysis::usage="SpiceTransientAnalysis[file, start, stop] links MathSpice, sources the file, performs an AC analysis, saves the data, unlinks MathSpice, and returns the data";

SpiceAnalysisBranches::usage="SpiceAnalysisBranches[data] lists the branches available in the data set. SpiceAnalysisBranches[] calls SpiceAnalysisBranches[data] on the last set of calculated data.";
SpiceAnalysisBranchIndexForName::usage="";
SpiceAnalysisBranchData::usage="SpiceAnalysisBranchData[data, name] returns the data set for the named branch from the data set. SpiceAnalysisBranchData[name] calls SpiceAnalysisBranchData[data, name] on the last set of calculated data.";

Begin["`Private`"];

SpiceHelp[]:=Module[{link},
Information[#,LongForm->False]&/@{SpiceHelp,SpiceTransientAnalysis,SpiceACAnalysis,SpiceAnalysisBranches,SpiceAnalysisBranchData};
link=Install["MathSpice`"];
Information[#,LongForm->False]&/@LinkPatterns[link][[;;,1,0]];
Uninstall[link];
];

(*link=Null;
SpiceConnect[]:=(link=Install["MathSpice"];Null);
SpiceDisconnect[]:=(LinkClose[link];Null);*)

lastData=Null;
SpiceTransientAnalysis[file_,args___]:=Module[{link},
link=Install["MathSpice`"];
SpiceSource[file];
lastData=SpiceTransient@args;
Uninstall[link];
lastData
];
SpiceACAnalysis[file_,args___]:=Module[{link},
link=Install["MathSpice`"];
SpiceSource[file];
lastData=SpiceAC@args;
Uninstall[link];
lastData
];

SpiceAnalysisBranches[]:=SpiceAnalysisBranches[lastData];
SpiceAnalysisBranches[data_]:=Table[Rule[i,#[[i]]],{i,Length@#}]&@data[[2;;,1]];
SpiceAnalysisBranchIndexForName[name_]:=SpiceAnalysisBranchIndexForName[lastData,name];
SpiceAnalysisBranchIndexForName[data_,name_]:=Position[data[[2;;,1]],name][[1,1]];
SpiceAnalysisBranchData[name_]:=SpiceAnalysisBranchData[lastData,name];
SpiceAnalysisBranchData[data_,name_]:=ReplacePart[data[[SpiceAnalysisBranchIndexForName[data,name]+1,2;;]],0->List];

End[];

EndPackage[];
