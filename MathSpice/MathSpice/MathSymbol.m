//
//  MathSymbol.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MathSymbol.h"

@implementation MathSymbol {
	NSString * _backing;
}

+ (instancetype)symbolWithString:(NSString *)aString
{
	return [[self alloc] initWithString:aString];
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

@end
