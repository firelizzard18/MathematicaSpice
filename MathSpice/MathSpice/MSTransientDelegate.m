//
//  MSTransientDelegate.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/10/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MSTransientDelegate.h"
#import "MathSpice.h"
#import "MathSymbol.h"
#import "MathFunction.h"

@interface MSTransientDelegate () {
	MathFunction * _initialData;
	NSMutableArray * _data;
}

@end

@implementation MSTransientDelegate

+ (instancetype)command
{
	NSNumber * step, * stop, * start = (id)[NSNull null], * max = (id)[NSNull null];
	MathSymbol * uic = (id)[NSNull null];
	NSString * command;
	MathFunction * opt;
	
	step = [MathSpice getObjectForPacketAndUnwrap];
	stop = [MathSpice getObjectForPacketAndUnwrap];
	
	while (MLReady(stdlink)) {
		opt = [MathSpice getObjectForPacketAndUnwrap];
		
		if (![opt isKindOfClass:MathFunction.class])
			goto bad_tpu;
		
		if (![opt.name isEqualToString:@"Rule"])
			goto bad_tpu;
		
		if (opt.count < 2)
			goto bad_tpu;
		
		MathSymbol * rule = opt[0];
		
		if (![rule isKindOfClass:MathSymbol.class])
			goto bad_tpu;
		
		id arg = opt[1];
		
		if ([rule isEqualToString:@"MathSpice`TransientStartTime"])
			start = arg;
		else if ([rule isEqualToString:@"MathSpice`TransientMaxStep"])
			max = arg;
		else if ([rule isEqualToString:@"MathSpice`TransientUseInitialConditions"])
			uic = arg;
		else
			goto bad_tpu;
	}
	
	if ([step isKindOfClass:MathFunction.class])
		step = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:step, nil]];
	if (![step isKindOfClass:NSNumber.class])
		goto bad_tp1;
	
	if ([stop isKindOfClass:MathFunction.class])
		stop = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:stop, nil]];
	if (![stop isKindOfClass:NSNumber.class])
		goto bad_tp2;
	
	if ([start isKindOfClass:MathFunction.class])
		start = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:start, nil]];
	if (!([start isKindOfClass:NSNumber.class] || [start isKindOfClass:NSNull.class]))
		goto bad_tst;
	
	if ([max isKindOfClass:MathFunction.class])
		max = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:max, nil]];
	if (!([max isKindOfClass:NSNumber.class] || [max isKindOfClass:NSNull.class]))
		goto bad_tms;
	
	if (![uic isKindOfClass:NSNull.class] && ![uic isKindOfClass:MathSymbol.class])
		goto bad_tuic;
	
	if ([start isKindOfClass:NSNull.class] && ![max isKindOfClass:NSNull.class])
		[MathSpice putError:@"MathSpice`SpiceTransient::TMSwoTST" withMessage:nil];
	
	command = [NSString stringWithFormat:@"tran %g %g", step.doubleValue, stop.doubleValue];
	if (![start isKindOfClass:NSNull.class]) {
		command = [command stringByAppendingFormat:@" %g", start.doubleValue];
		if (![max isKindOfClass:NSNull.class])
			command = [command stringByAppendingFormat:@" %g", max.doubleValue];
	}
	if (![uic isKindOfClass:NSNull.class] && [uic.lowercaseString isEqualToString:@"true"])
		command = [command stringByAppendingString:@" uic"];
	
	return [[self alloc] initWithCommand:command];
	
bad_tp1:
	[MathSpice putError:@"MathSpice`SpiceTransient::badTP1" withMessage:nil];
	goto error;
	
bad_tp2:
	[MathSpice putError:@"MathSpice`SpiceTransient::badTP2" withMessage:nil];
	goto error;
	
bad_tpu:
	[MathSpice putError:@"MathSpice`SpiceTransient::badTPU" withMessage:[MathSpice descriptionOfObject:opt]];
	goto error;
	
bad_tst:
	[MathSpice putError:@"MathSpice`SpiceTransient::badTST" withMessage:nil];
	goto error;
	
bad_tms:
	[MathSpice putError:@"MathSpice`SpiceTransient::badTMS" withMessage:nil];
	goto error;
	
bad_tuic:
	[MathSpice putError:@"MathSpice`SpiceTransient::badTUIC" withMessage:nil];
	goto error;
	
	
failed:
	[MathSpice putError];
	
error:
	return nil;
}

- (id)initWithCommand:(NSString *)command
{
	if (!(self = [super initWithCommand:command]))
		return nil;
	
	_initialData = nil;
	_data = @[].mutableCopy;
	
	return self;
}

- (int)receivedInitialData:(vecinfoall *)info
{
	_initialData = [MathFunction functionWithName:@"List" andArguments:nil];
	
	return 0;
}

- (int)receivedData:(vecvaluesall *)values count:(NSUInteger)count
{
//	NSMutableArray * arr = [NSMutableArray arrayWithCapacity:values->veccount];
//	for (int j = 0; j < values->veccount; j++) {
//		vecvalues * value = values->vecsa[j];
//		[arr addObject:[MathFunction functionWithName:@"List"
//										 andArguments:@(value->name),
//													  @(value->is_scale),
//													  @(value->is_complex),
//													  @(value->creal),
//													  @(value->cimag), nil]];
//	}
//	[_data addObject:[MathFunction functionWithName:@"List" andArgumentsArray:arr]];
	
	return 0;
}

- (void)putResponse
{
	if (self.failed)
		return;
	
	MathFunction * resp = [MathFunction functionWithName:@"List" andArguments:_initialData, [MathFunction functionWithName:@"List" andArgumentsArray:_data], nil];
	[MathSpice putPacketForObject:resp];
}

@end
