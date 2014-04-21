//
//  MathOption.m
//  MathSpice
//
//  Created by Ethan Reesor on 4/21/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MathRule.h"

#import "MathSpice.h"

@implementation MathRule

+ (id<MathObject>)getRuleOrObject
{
	id<MathObject> obj;
	MathFunction * func;
	MathRule * rule;
	
	obj = [MathSpice getObjectForPacket];
	if (![obj isKindOfClass:MathFunction.class])
		return obj;
	
	func = (MathFunction *)obj;
	if (!(rule = [[self alloc] initWithArray:func name:func.name]))
		return func;
	
	return rule;
}

- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt name:(NSString *)name
{
	if (cnt != 2)
		return nil;
	
	if (![name isEqualToString:@"Rule"] || ![name isEqualToString:@"RuleDelayed"])
		return nil;
	
	return [super initWithObjects:objects count:cnt name:name];
}

- (id)initWithArray:(NSArray *)array name:(NSString *)name
{
	if (array.count != 2)
		return nil;
	
	if (![name isEqualToString:@"Rule"] || ![name isEqualToString:@"RuleDelayed"])
		return nil;
	
	return [super initWithArray:array name:name];
}

- (id<MathObject>)lhs
{
	return self[0];
}

- (id<MathObject>)rhs
{
	return self[1];
}

@end
