//
//  MSSourceDelegate.m
//  MathSpice
//
//  Created by Ethan Reesor on 4/20/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MSSourceDelegate.h"

@implementation MSSourceDelegate

+ (instancetype)command
{
	const char * sp;
	MLGetString(stdlink, &sp);
	return [self commandWithCommand:[NSString stringWithFormat:@"source %s", sp]];
}

@end
