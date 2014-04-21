//
//  MathOption.h
//  MathSpice
//
//  Created by Ethan Reesor on 4/21/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MathFunction.h"

@interface MathRule : MathFunction

+ (id<MathObject>)getRuleOrObject;

- (id<MathObject>)lhs;
- (id<MathObject>)rhs;

@end
