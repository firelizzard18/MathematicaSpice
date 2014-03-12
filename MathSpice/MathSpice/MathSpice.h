//
//  MathSpice.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mathlink/mathlink.h>

#import "MSDelegate.h"

@interface MathSpice : NSObject

@property id<MSDelegate> delegate;

+ (id)getObjectForPacket:(MLINK)link;

- (void)execute;

@end
