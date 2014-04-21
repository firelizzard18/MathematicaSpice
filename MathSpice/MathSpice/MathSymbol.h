//
//  MathSymbol.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/11/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "include.h"

#import "MathObject.h"

@interface MathSymbol : NSString <MathObject>

- (NSString *)context;
- (NSString *)unquallifiedName;
- (NSString *)fullyQuallifiedName;

@end
