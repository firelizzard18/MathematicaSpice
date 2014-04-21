//
//  MathFunction.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "include.h"

#import "MathObject.h"

@interface MathFunction : NSArray <MathObject>

@property (readonly) NSString * name;

+ (instancetype)functionWithName:(NSString *)name andArgumentsArray:(NSArray *)args;
+ (instancetype)functionWithName:(NSString *)name andArguments:(id)first, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt name:(NSString *)name;
- (id)initWithArray:(NSArray *)array name:(NSString *)name;

- (NSNumber *)N;

@end
