/* To launch this program from within Mathematica use:
 *   In[1]:= link = Install["addtwo"]
 *
 * Or, launch this program from a shell and establish a
 * peer-to-peer connection.  When given the prompt Create Link:
 * type a port name. ( On Unix platforms, a port name is a
 * number less than 65536.  On Mac or Windows platforms,
 * it's an arbitrary word.)
 * Then, from within Mathematica use:
 *   In[1]:= link = Install["portname", LinkMode->Connect]
 */

#include "mathlink.h"
#import "MathSpice.h"

extern char * spice_exec(const char * cmd);

static MathSpice * ms = nil;

int main(int argc, char* argv[])
{
	int ret = 0;
	
	ms = [MathSpice new];
	[ms launch];
	ret = MLMain(argc, argv);
	[ms terminate];
	
	return ret;
}

char * spice_exec(const char * cmd)
{
	[ms run:@(cmd)];
	sleep(1);
	return ms.popData.bytes;
}

