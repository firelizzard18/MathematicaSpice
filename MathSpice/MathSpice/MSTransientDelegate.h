//
//  MSTransientDelegate.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/10/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "include.h"
#import "MSCommandDelegate.h"

@class MathFunction;

@interface MSTransientDelegate : MSCommandDelegate <MSDelegate> {
	MathFunction * _initialData;
	NSMutableArray * _data;
}

@end
