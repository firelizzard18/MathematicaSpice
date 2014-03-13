//
//  MathSpice.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "include.h"
#import "MSDelegate.h"

@interface MathSpice : NSObject

+ (id)getObjectForPacket;
+ (id)getObjectForPacketAndUnwrap;
+ (int)putPacketForObject:(id)obj;
+ (NSString *)descriptionOfObject:(id)obj;
+ (id)evaluateObject:(id)obj;

- (void)execute:(id<MSDelegate>)delegate;

+ (void)putError;
+ (void)putError:(NSString *)error withMessage:(NSString *)message;

@end
