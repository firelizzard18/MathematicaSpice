//
//  MathSpice.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/6/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathSpice : NSObject

- (void)launch;
- (void)terminate;
- (void)run:(NSString *)cmd;
- (NSData *)popData;
- (NSData *)popError;

@end
