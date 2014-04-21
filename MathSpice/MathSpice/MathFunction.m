//
//  MathFunction.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "include.h"
#import "MathFunction.h"
#import "MathSpice.h"

@implementation MathFunction {
	NSArray * _backing;
}

+ (instancetype)get
{
	const char * func;
	int count;
	if (!MLGetFunction(stdlink, &func, &count))
		goto failed;
	
	{
		id objs[count];
		for (int i = 0; i < count; i++) {
			id obj = [MathSpice getObjectForPacket];
			if (!obj)
				goto error;
			objs[i] = obj;
		}
		
		return [[self alloc] initWithObjects:objs count:count name:@(func)];
	}
	
failed:
	[MathSpice putError];
error:
	return nil;
}

+ (instancetype)functionWithName:(NSString *)name andArgumentsArray:(NSArray *)args
{
	return [[self alloc] initWithArray:args name:name];
}

+ (instancetype)functionWithName:(NSString *)name andArguments:(id)first, ...
{
	if (!first)
		return [self functionWithName:name andArgumentsArray:@[]];
	
	NSMutableArray * arr = @[first].mutableCopy;
	
	va_list ap;
	va_start(ap, first);
	while ((first = va_arg(ap, id)))
		[arr addObject:first];
	va_end(ap);
	
	return [self functionWithName:name andArgumentsArray:arr];
}

- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt name:(NSString *)name
{
	_name = name;
	_backing = [NSArray arrayWithObjects:objects count:cnt];
	
	return self;
}

- (id)initWithArray:(NSArray *)array name:(NSString *)name
{
	_name = name;
	_backing = [NSArray arrayWithArray:array];
	
	return self;
}

- (NSUInteger)count
{
	return _backing.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
	return [_backing objectAtIndex:index];
}

- (int)put
{
	int ret = MLPutFunction(stdlink, self.name.UTF8String, (int)self.count);
	
	for (int i = 0; ret && i < self.count; i++)
		ret = [MathSpice putPacketForObject:self[i]];
	
	return ret;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@[%@]", self.name, [self componentsJoinedByString:@","]];
}

- (NSNumber *)N
{
	NSNumber * val = [MathSpice evaluateObject:[MathFunction functionWithName:@"N" andArguments:self, nil]];
	
	if (![val isKindOfClass:NSNumber.class])
		return nil;
	
	return val;
}

@end
