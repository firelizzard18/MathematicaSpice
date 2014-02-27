MathematicaSpice
================

This project aims to be a GUI wrapper for [ngspice](http://ngspice.sourceforge.net/).

Eventually, this will have pretty buttons and forms for running the various analyses that ngspice supports.

It will probably not ever have a circuit designer.

##How it works
MathematicaSpice calls ngspice in batch mode and reads ngspice's stdout.  Then we interpret the response into a list.
