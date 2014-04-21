//
//  MSAnalysisDelegate.m
//  MathSpice
//
//  Created by Ethan Reesor on 4/20/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MSAnalysis.h"

#import "MathSpice.h"
#import "MathSymbol.h"
#import "MathFunction.h"

@implementation MSAnalysis {
	MathFunction * _initialData;
	NSMutableDictionary * _data;
}

- (id)initWithCommand:(NSString *)command
{
	if (!(self = [super initWithCommand:command]))
		return nil;
	
	_initialData = nil;
	_data = @{}.mutableCopy;
	
	return self;
}

- (int)receivedInitialData:(vecinfoall *)info
{
	_initialData = [MathFunction functionWithName:@"MathSpice`AnalysisDataInitial" andArguments:nil];
	
	return 0;
}

- (int)receivedData:(vecvaluesall *)values count:(NSUInteger)count
{
	for (int j = 0; j < values->veccount; j++) {
		vecvalues * value = values->vecsa[j];
		NSMutableArray * arr = _data[@(value->name)];
		
		if (!arr)
			_data[@(value->name)] = arr = [NSMutableArray array];
		
		if (value->is_complex)
			[arr addObject:[MathFunction functionWithName:@"Complex" andArguments:@(value->creal), @(value->cimag), nil]];
		else
			[arr addObject:@(value->creal)];
	}
	
	return 0;
}

- (void)putResponse
{
	if (self.failed)
		return;
	
	NSMutableArray * data = [NSMutableArray arrayWithCapacity:_data.count + 1];
	[data addObject:_initialData];
	
	for (NSString * branch in _data) {
		NSMutableArray * bdata = [_data[branch] mutableCopy];
		[bdata insertObject:branch atIndex:0];
		[data addObject:[MathFunction functionWithName:@"MathSpice`AnalysisDataBranch" andArgumentsArray:bdata]];
	}
	
	MathFunction * resp = [MathFunction functionWithName:@"MathSpice`AnalysisData" andArgumentsArray:data];
	[MathSpice putPacketForObject:resp];
}

@end
