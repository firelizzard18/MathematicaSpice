//
//  MSDelegate.h
//  MathSpice
//
//  Created by Ethan Reesor on 3/10/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ngspice/sharedspice.h>

@protocol MSDelegate <NSObject>

- (BOOL)failed;

- (void)run;

- (int)receivedMessage:(NSString *)message;
- (int)receivedStatus:(NSString *)status;
- (int)receivedInitialData:(vecinfoall *)info;
- (int)receivedData:(vecvaluesall *)values count:(NSUInteger)count;

- (void)putFailureResponse;
- (void)putResponse;

@end
