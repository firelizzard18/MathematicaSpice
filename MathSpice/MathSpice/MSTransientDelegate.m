//
//  MSTransientDelegate.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/10/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MSTransientDelegate.h"

@implementation MSTransientDelegate

- (id)init
{
	{
		int tmp;
		const char * sym;
		double step, stop, start, max;
		bool uic;
		NSString * command;
		
		if (!MLGetReal(stdlink, &step) | !MLGetReal(stdlink, &stop))
			goto failed;
		
		if (!MLNewPacket(stdlink) | !MLEvaluate(stdlink, "OptionValue[MathSpice`TransientStartTime]"))
			goto failed;
		
		switch (MLGetType(stdlink)) {
			case MLTKINT:
				if (!MLGetInteger(stdlink, &tmp))
					goto failed;
				start = (double)tmp;
				break;
				
			case MLTKREAL:
				if (!MLGetReal(stdlink, &start))
					goto failed;
				break;
				
			case MLTKNULL:
				start = NAN;
				break;
				
			default:
				[self fail];
				[self putError:@"MathSpice`SpiceTransient::badTST" withMessage:nil];
				goto error;
		}
		
		if (!MLNewPacket(stdlink) | !MLEvaluate(stdlink, "OptionValue[MathSpice`TransientMaxStep]"))
			goto failed;
		
		switch (MLGetType(stdlink)) {
			case MLTKINT:
				if (!MLGetInteger(stdlink, &tmp))
					goto failed;
				max = (double)tmp;
				break;
				
			case MLTKREAL:
				if (!MLGetReal(stdlink, &max))
					goto failed;
				break;
				
			case MLTKNULL:
				max = NAN;
				break;
				
			default:
				[self fail];
				[self putError:@"MathSpice`SpiceTransient::badTMS" withMessage:nil];
				goto error;
		}
		
		if (start == NAN && max != NAN)
			[self putError:@"MathSpice`SpiceTransient::TMSwoTST" withMessage:nil];
		
		if (!MLNewPacket(stdlink) | !MLEvaluate(stdlink, "OptionValue[MathSpice`TransientUseInitialConditions]"))
			goto failed;
		
		switch (MLGetType(stdlink)) {
			case MLTKSYM:
				if (!MLGetSymbol(stdlink, &sym))
					goto failed;
				
				if (strcasecmp("true", sym))
					uic = true;
				else if (strcasecmp("false", sym))
					uic = false;
				else {
					[self putError:@"MathSpice`SpiceTransient::badTUIC" withMessage:nil];
					goto error;
				}
				
				
			case MLTKNULL:
				uic = false;
				break;
				
			default:
				[self putError:@"MathSpice`SpiceTransient::badTUIC" withMessage:nil];
				goto error;
		}
		
		command = [NSString stringWithFormat:@"tran %g %g", step, stop];
		if (start != NAN) {
			command = [command stringByAppendingFormat:@" %g", start];
			if (max != NAN)
				command = [command stringByAppendingFormat:@" %g", max];
		}
		if (uic)
			command = [command stringByAppendingString:@" uic"];
		
		if (!(self = [super initWithCommand:command]))
			return nil;
	}
	
	return self;
	
failed:
	[self putError];
error:
	return nil;
}

- (int)receivedInitialData:(vecinfoall *)info
{
	return 0;
}

- (int)receivedData:(vecvaluesall *)values count:(NSUInteger)count
{
	return 0;
}

@end
