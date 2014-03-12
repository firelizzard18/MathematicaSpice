//
//  MSCommandDelegate.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MSCommandDelegate.h"

@implementation MSCommandDelegate {
	NSString * _command;
}

+ (instancetype)commandWithCommand:(NSString *)command
{
	return [[self alloc] initWithCommand:command];
}

+ (instancetype)command
{
	const char * sp;
	MLGetString(stdlink, &sp);
	return [self commandWithCommand:@(sp)];
}

- (id)initWithCommand:(NSString *)command
{
	if (!(self = [super init]))
		return nil;
	
	_command = command;
	_failed = NO;
	
	return self;
}

- (int)receivedMessage:(NSString *)message
{
	NSString * error = nil;
	if ([message hasPrefix:@"stderr"]) {
		message = [message substringFromIndex:7];
		
		if ([message hasPrefix:@"Warning:"]) {
			message = [message substringFromIndex:9];
			error = @"MathSpice`Warn::spice";
		} else {
			[self fail];
			if ([message hasPrefix:@"Error:"])
				message = [message substringFromIndex:7];
			error = @"MathSpice`Error::spice";
		}
		
		goto err;
	}
done:
	return 0;
	
err:
	[self putError:error withMessage:message];
	goto  done;
}

- (int)receivedStatus:(NSString *)status
{
	return 0;
}

- (int)receivedInitialData:(vecinfoall *)info
{
	return 0;
}

- (int)receivedData:(vecvaluesall *)values count:(NSUInteger)count
{
	return 0;
}

- (void)run
{
	_failed |= ngSpice_Command((char *)_command.UTF8String);
}

- (void)fail
{
	_failed = YES;
}

- (void)putError
{
	NSString * message = @(MLErrorMessage(stdlink));
	[self fail];
	MLClearError(stdlink);
	[self putError:@"MathSpice`Error::mlink" withMessage:message];
}

- (void)putError:(NSString *)error withMessage:(NSString *)message
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

- (void)putFailureResponse
{
	if (!MLNewPacket(stdlink))
		[self putError];
	if (!MLPutSymbol(stdlink, "$Failed"))
		[self putError];
}

- (void)putResponse
{
	if (self.failed)
		return;
	
	MLPutSymbol(stdlink, "Null");
}

@end
