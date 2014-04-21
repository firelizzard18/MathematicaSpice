(* ::Package:: *)

BeginPackage["MathSpice`"];

SpiceHelp::usage="SpiceHelp[] prints usage information for various MathSpice functions";
SpiceConnect::usage="SpiceConnect[] links the MathSpice executable";
SpiceDisconnect::usage="SpiceDisconnect[] unlinks the MathSpice executable";

SpiceTransientAnalysis::usage="";
SpiceACAnalysis::usage="";

SpiceAnalysistBranches::usage="";
SpiceAnalysisBranchIndexForName::usage="";
SpiceAnalysisBranchData::usage="";

Begin["`Private`"];

SpiceHelp[]:=(Information[#,LongForm->False]&/@Join[{SpiceHelp},#[[1,0]]&/@LinkPatterns[link]];Null);

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

SpiceAnalysistBranches[]:=SpiceAnalysistBranches[lastData];
SpiceAnalysistBranches[data_]:=Table[Rule[i,#[[i]]],{i,Length@#}]&@data[[2;;,1]];
SpiceAnalysisBranchIndexForName[name_]:=SpiceAnalysisBranchIndexForName[lastData,name];
SpiceAnalysisBranchIndexForName[data_,name_]:=Position[data[[2;;,1]],name][[1,1]];
SpiceAnalysisBranchData[name_]:=SpiceAnalysisBranchData[lastData,name];
SpiceAnalysisBranchData[data_,name_]:=ReplacePart[data[[SpiceAnalysisBranchIndexForName[data,name]+1,2;;]],0->List];


End[];

EndPackage[];
