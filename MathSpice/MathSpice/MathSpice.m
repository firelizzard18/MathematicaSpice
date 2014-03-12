//
//  MathSpice.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MathSpice.h"

int _send_char(char * msgstr, int idnum, void * vptr) {
	MathSpice * self = (__bridge id)vptr;
	return [self.delegate receivedMessage:@(msgstr)];
}

int _send_stat(char * status, int idnum, void * vptr) {
	MathSpice * self = (__bridge id)vptr;
	return [self.delegate receivedStatus:@(status)];
}

int _controlled_exit(int status, bool imm_unload_dll, bool no_error, int idnum, void * vptr) {
	return 0;
}

int _send_data(vecvaluesall * vectors, int count, int idnum, void * vptr) {
	MathSpice * self = (__bridge id)vptr;
	return [self.delegate receivedData:vectors count:count];
}

int _send_init_data(vecinfoall * vectors, int idnum, void * vptr) {
	MathSpice * self = (__bridge id)vptr;
	return [self.delegate receivedInitialData:vectors];
}

int _background_thread_running(bool is_running, int idnum, void * vptr) {
	return 0;
}

@implementation MathSpice

+ (id)getObjectForPacket:(MLINK)link
{
	switch (MLGetType(stdlink)) {
		case <#constant#>:
			<#statements#>
			break;
			
		default:
			break;
	}
}

- (id)init
{
	if (!(self = [super init]))
		return nil;
	
	ngSpice_Init(&_send_char,
				 &_send_stat,
				 &_controlled_exit,
				 &_send_data,
				 &_send_init_data,
				 &_background_thread_running,
				 (__bridge void *)self);
	
	return self;
}

- (void)execute
{
	[self.delegate run];
	if (self.delegate.failed)
		[self.delegate putFailureResponse];
	[self.delegate putResponse];
}

- (void)dealloc
{
	self.delegate = nil;
}

@end
