//
//  MSCommandDelegate.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mathlink.h>

#import "MSDelegate.h"

@interface MSCommandDelegate : NSObject <MSDelegate>

@property (readonly) BOOL failed;

+ (instancetype)commandWithCommand:(NSString *)command;
+ (instancetype)command;
- (id)initWithCommand:(NSString *)command;

@end
