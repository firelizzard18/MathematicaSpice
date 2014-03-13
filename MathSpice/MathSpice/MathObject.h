//
//  MathObject.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "include.h"

@protocol MathObject <NSObject>

+ (instancetype)get;
- (int)put;

@end
