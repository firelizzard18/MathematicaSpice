MathematicaSpice
================

This project aims to be a GUI wrapper for [ngspice](http://ngspice.sourceforge.net/).

Eventually, this will have pretty buttons and forms for running the various analyses that ngspice supports.

It will probably not ever have a circuit designer.

##Dependencies
###Installing NGSpice libs
Clone [ngspice](git://git.code.sf.net/p/ngspice/ngspice), `./autogen.sh`, `./configure --enable-xspice --enable-cider --disable-debug --with-ngshared`, `make`, `make install`

##How it works
MathematicaSpice calls ngspice in batch mode and reads ngspice's stdout.  Then we interpret the response into a list.
