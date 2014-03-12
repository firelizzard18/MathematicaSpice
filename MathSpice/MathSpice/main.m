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

#include <stdbool.h>
#include <stdio.h>

#include <mathlink.h>

#import "MathSpice.h"
#import "MSCommandDelegate.h"
#import "MSTransientDelegate.h"

extern void spice_exec(void);
extern void spice_data(void);
extern void spice_tran(void);
extern void spice_ac(void);
extern void spice_dc(void);

static MathSpice * ms;

int main(int argc, char * argv[])
{
	int ret = 0;
	
	ms = [MathSpice new];
	ret = MLMain(argc, argv);
	
	return ret;
}

void spice_exec(void)
{
	ms.delegate = [MSCommandDelegate command];
	[ms execute];
}

void spice_data(void) {
	
}

void spice_tran(void) {
	
}

void spice_ac(void) {
	
}

void spice_dc(void) {
	
}