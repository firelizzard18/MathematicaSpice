//
//  MSACDelegate.m
//  MathSpice
//
//  Created by Ethan Reesor on 4/20/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MSACDelegate.h"

#import "MathSpice.h"
#import "MathSymbol.h"
#import "MathFunction.h"

@implementation MSACDelegate

+ (instancetype)command
{
	NSString		* mode = nil;
	NSNumber		* points,
					* start,
					* stop,
					* dec_points = nil,
					* oct_points = nil,
					* lin_points = nil;
	MathFunction	* opt;
	
	start = [MathSpice getObjectForPacketAndUnwrap];
	stop = [MathSpice getObjectForPacketAndUnwrap];
	
	while (MLReady(stdlink)) {
		opt = [MathSpice getObjectForPacketAndUnwrap];
		
		if (![opt isKindOfClass:MathFunction.class])
			goto bad_paramU;
		
		if (![opt.name isEqualToString:@"Rule"])
			goto bad_paramU;
		
		if (opt.count < 2)
			goto bad_paramU;
		
		MathSymbol * rule = opt[0];
		
		if (![rule isKindOfClass:MathSymbol.class])
			goto bad_paramU;
		
		rule = [MathSpice evaluateObject:[MathFunction functionWithName:@"StringJoin"
														   andArguments:[MathFunction functionWithName:@"Context"
																						  andArguments:rule, nil],
																		[MathFunction functionWithName:@"SymbolName"
																						  andArguments:[MathFunction functionWithName:@"Unevaluated"
																														 andArguments:rule, nil],
																									   nil],
																		nil]
				];
		
		id arg = opt[1];
		
		if ([rule isEqualToString:@"MathSpice`ACMode"])
			mode = arg;
		else if ([rule isEqualToString:@"MathSpice`ACPointsPerDecade"])
			dec_points = arg;
		else if ([rule isEqualToString:@"MathSpice`ACPointsPerOctave"])
			oct_points = arg;
		else if ([rule isEqualToString:@"MathSpice`ACLinearPoints"])
			lin_points = arg;
		else
			goto bad_paramU;
	}
	
	if ([start isKindOfClass:MathFunction.class])
		start = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:start, nil]];
	if (![start isKindOfClass:NSNumber.class])
		goto bad_param1;
	
	if ([stop isKindOfClass:MathFunction.class])
		stop = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:stop, nil]];
	if (![stop isKindOfClass:NSNumber.class])
		goto bad_param2;
	
	if (!mode)
		mode = @"dec";
	if (![mode isKindOfClass:NSString.class])
		goto bad_opt_mode;
	
	if (!dec_points)
		dec_points = @(100);
	else if ([dec_points isKindOfClass:MathFunction.class])
		dec_points = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:dec_points, nil]];
	if (![dec_points isKindOfClass:NSNumber.class])
		goto bad_opt_dec;
	
	if (!oct_points)
		oct_points = @(100);
	else if ([oct_points isKindOfClass:MathFunction.class])
		oct_points = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:oct_points, nil]];
	if (![oct_points isKindOfClass:NSNumber.class])
		goto bad_opt_oct;
	
	if (!lin_points)
		lin_points = @(100);
	else if ([lin_points isKindOfClass:MathFunction.class])
		lin_points = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:lin_points, nil]];
	if (![lin_points isKindOfClass:NSNumber.class])
		goto bad_opt_lin;
	
	if ([mode isEqual:@"dec"])
		points = dec_points;
	else if ([mode isEqual:@"oct"])
		points = oct_points;
	else if ([mode isEqual:@"lin"])
		points = lin_points;
	else
		goto bad_opt_mode;
	
	return [[self alloc] initWithCommand:[NSString stringWithFormat:@"ac %s %g %g %g", mode.UTF8String, points.doubleValue, start.doubleValue, stop.doubleValue]];
	
bad_param1:
	[MathSpice putError:@"MathSpice`SpiceAC::badParam1" withMessage:nil];
	goto error;
	
bad_param2:
	[MathSpice putError:@"MathSpice`SpiceAC::badParam2" withMessage:nil];
	goto error;
	
bad_paramU:
	[MathSpice putError:@"MathSpice`SpiceAC::badParamU" withMessage:[MathSpice descriptionOfObject:opt]];
	goto error;
	
bad_opt_mode:
	[MathSpice putError:@"MathSpice`SpiceAC::badOptMode" withMessage:nil];
	goto error;
	
bad_opt_dec:
	[MathSpice putError:@"MathSpice`SpiceAC::badOptDec" withMessage:nil];
	goto error;
	
bad_opt_oct:
	[MathSpice putError:@"MathSpice`SpiceAC::badOptOct" withMessage:nil];
	goto error;
	
bad_opt_lin:
	[MathSpice putError:@"MathSpice`SpiceAC::badOptLin" withMessage:nil];
	goto error;
	
	
failed:
	[MathSpice putError];
	
error:
	return nil;
}

@end
