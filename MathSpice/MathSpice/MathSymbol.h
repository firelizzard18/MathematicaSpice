//
//  MathSymbol.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathSymbol : NSString

+ (instancetype)symbolWithString:(NSString *)aString;
- (id)initWithString:(NSString *)aString;

@end
