//
//  MathSpice.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MathSpice.h"
#import "MathObject.h"
#import "MathSymbol.h"
#import "MathFunction.h"

@interface MathSpice ()

- (id<MSDelegate>)delegate;

@end

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

@implementation MathSpice {
	id<MSDelegate> _delegate;
}

+ (id)getObjectForPacket
{
	int t;
	switch (t = MLGetType(stdlink)) {
		case MLTKNULL: {
			return [NSNull null];
		}
		
		case MLTKINT: {
			long tmp;
			if (!MLGetLongInteger(stdlink, &tmp))
				goto failed;
			return @(tmp);
		}
		
		case MLTKREAL: {
			double tmp;
			MLGetReal(stdlink, &tmp);
			return @(tmp);
		}
			
		case MLTKSTR: {
			const char * tmp;
			MLGetString(stdlink, &tmp);
			return @(tmp);
		}
			
		case MLTKSYM:
			return [MathSymbol get];
			
		case MLTKFUNC:
			return [MathFunction get];
			
		default:
			return nil;
	}
	
failed:
	[self.class putError];
	return nil;
}

+ (id)getObjectForPacketAndUnwrap
{
	id obj = [self getObjectForPacket];
	if ([obj isKindOfClass:MathFunction.class] && [[(MathFunction *)obj name] isEqualToString:@"ReturnPacket"])
		obj = [(MathFunction *)obj objectAtIndex:0];
	return obj;
}

+ (int)putPacketForObject:(id)obj
{
	if ([obj conformsToProtocol:@protocol(MathObject)])
		return [(id<MathObject>)obj put];
	
	else if ([obj isKindOfClass:NSNull.class])
		return MLPutSymbol(stdlink, "Null");
	
	else if ([obj isKindOfClass:NSString.class])
		return MLPutString(stdlink, [(NSString *)obj UTF8String]);
	
	else if ([obj isKindOfClass:NSNumber.class])
		return MLPutReal(stdlink, [(NSNumber *)obj doubleValue]);
	
	else
		return -1;
}

+ (NSString *)descriptionOfObject:(id)obj
{
	if ([obj conformsToProtocol:@protocol(MathObject)])
		return [(id<NSObject>)obj description];
	
	else if ([obj isKindOfClass:NSNull.class])
		return @"Null";
	
	else if ([obj isKindOfClass:NSString.class])
		return [NSString stringWithFormat:@"\"%@\"", obj];
	
	else if ([obj isKindOfClass:NSNumber.class])
		return [(id<NSObject>)obj description];
	
	else
		return nil;
}

+ (id)evaluateObject:(id)obj
{
	NSString * desc = [self descriptionOfObject:obj];
	if (!desc)
		return nil;
	
	if (!MLEvaluate(stdlink, (char *)desc.UTF8String) && !MLNextPacket(stdlink))
		return nil;
	
	return [self getObjectForPacketAndUnwrap];
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

- (id<MSDelegate>)delegate
{
	return _delegate;
}

- (void)execute:(id<MSDelegate>)delegate
{
	_delegate = delegate;
	
	[self.delegate run];
	if (!self.delegate || self.delegate.failed)
		[self putFailureResponse];
	[self.delegate putResponse];
}

- (void)putFailureResponse
{
	if (!MLNewPacket(stdlink)) {
		[self.delegate fail];
		[self.class putError];
	}
	if (!MLPutSymbol(stdlink, "$Failed")) {
		[self.delegate fail];
		[self.class putError];
	}
}

- (void)dealloc
{
	_delegate = nil;
}

+ (void)putError
{
	NSString * message = @(MLErrorMessage(stdlink));
	MLClearError(stdlink);
	[self putError:@"MathSpice`Error::mlink" withMessage:message];
}

+ (void)putError:(NSString *)error withMessage:(NSString *)message
{
	NSString * eval;
	if (message)
		eval = [NSString stringWithFormat:@"Message[%@, \"%@\"]", error, message];
	else
		eval = [NSString stringWithFormat:@"Message[%@]", error];
	
	MLNewPacket(stdlink);
	MLEvaluate(stdlink, (char *)eval.UTF8String);
	MLNextPacket(stdlink);
}

@end
