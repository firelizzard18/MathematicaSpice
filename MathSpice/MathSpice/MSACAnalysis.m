//
//  MSACDelegate.m
//  MathSpice
//
//  Created by Ethan Reesor on 4/20/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MSACAnalysis.h"

#import "MathSpice.h"
#import "MathSymbol.h"
#import "MathFunction.h"
#import "MathRule.h"

@implementation MSACAnalysis

+ (instancetype)command
{
	NSString		* mode = nil,
					* rule_lhs;
	NSNumber		* points,
					* start,
					* stop,
					* dec_points = nil,
					* oct_points = nil,
					* lin_points = nil;
	MathRule		* rule;
	
	start = [MathSpice getObjectForPacket];
	stop = [MathSpice getObjectForPacket];
	
	while (MLReady(stdlink)) {
		rule = (MathRule *)[MathRule getRuleOrObject];
		
		if (!rule || ![rule isKindOfClass:MathRule.class])
			goto bad_paramU;
		
		if (![rule.lhs isKindOfClass:MathSymbol.class])
			goto bad_paramU;
		
		rule_lhs = [(MathSymbol *)rule.lhs fullyQuallifiedName];
		
		if ([rule_lhs isEqualToString:@"MathSpice`ACMode"])
			mode = (NSString *)rule.rhs;
		else if ([rule_lhs isEqualToString:@"MathSpice`ACPointsPerDecade"])
			dec_points = (NSNumber *)rule.rhs;
		else if ([rule_lhs isEqualToString:@"MathSpice`ACPointsPerOctave"])
			oct_points = (NSNumber *)rule.rhs;
		else if ([rule_lhs isEqualToString:@"MathSpice`ACLinearPoints"])
			lin_points = (NSNumber *)rule.rhs;
		else
			goto bad_paramU;
	}
	
	if ([start isKindOfClass:MathFunction.class])
		start = [(MathFunction *)start N];
	if (![start isKindOfClass:NSNumber.class])
		goto bad_param1;
	
	if ([stop isKindOfClass:MathFunction.class])
		stop = [(MathFunction *)stop N];
	if (![stop isKindOfClass:NSNumber.class])
		goto bad_param2;
	
	if (!mode)
		mode = @"dec";
	if (![mode isKindOfClass:NSString.class])
		goto bad_opt_mode;
	
	if (!dec_points)
		dec_points = @(100);
	else if ([dec_points isKindOfClass:MathFunction.class])
		dec_points = [(MathFunction *)dec_points N];
	if (![dec_points isKindOfClass:NSNumber.class])
		goto bad_opt_dec;
	
	if (!oct_points)
		oct_points = @(100);
	else if ([oct_points isKindOfClass:MathFunction.class])
		oct_points = [(MathFunction *)oct_points N];
	if (![oct_points isKindOfClass:NSNumber.class])
		goto bad_opt_oct;
	
	if (!lin_points)
		lin_points = @(100);
	else if ([lin_points isKindOfClass:MathFunction.class])
		lin_points = [(MathFunction *)lin_points N];
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
	[MathSpice putError:@"MathSpice`SpiceAC::badParamU" withMessage:[MathSpice descriptionOfObject:rule]];
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
