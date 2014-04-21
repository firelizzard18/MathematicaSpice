//
//  MathSymbol.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MathSymbol.h"

#import <mathlink/mathlink.h>

#import "MathSpice.h"
#import "MathFunction.h"

@implementation MathSymbol {
	NSString * _backing;
}

+ (instancetype)get
{
	const char * tmp;
	MLGetSymbol(stdlink, &tmp);
	NSString * sym = @(tmp);
	if ([sym isEqualToString:@"Null"])
		return (MathSymbol *)[NSNull null];
	else
		return [[self alloc] initWithString:sym];
}

- (id)initWithString:(NSString *)aString
{
	_backing = [NSString stringWithString:aString];
	
	return self;
}

- (NSUInteger)length
{
	return _backing.length;
}

- (unichar)characterAtIndex:(NSUInteger)index
{
	return [_backing characterAtIndex:index];
}

- (void)getCharacters:(unichar *)buffer range:(NSRange)aRange
{
	[_backing getCharacters:buffer range:aRange];
}

- (int)put
{
	return MLPutSymbol(stdlink, _backing.UTF8String);
}

- (NSString *)context
{
	return [MathSpice evaluateObject:[MathFunction functionWithName:@"Context" andArguments:self, nil]];
}

- (NSString *)unquallifiedName
{
	return [MathSpice evaluateObject:[MathFunction functionWithName:@"SymbolName" andArguments:[MathFunction functionWithName:@"Unevaluated" andArguments:self, nil], nil]];
}

- (NSString *)fullyQuallifiedName
{
	return [self.context stringByAppendingString:self.unquallifiedName];
}

@end
