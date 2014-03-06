//
//  MathSpice.m
//  MathSpice
//
//  Created by Ethan Reesor on 3/6/14.
//  Copyright (c) 2014 Computing Eureka. All rights reserved.
//

#import "MathSpice.h"

@implementation MathSpice {
	NSTask * _ngspiceTask;
	NSPipe * _standardInput,
	       * _standardOutput,
	       * _standardError;
	NSMutableArray * _data,
	               * _error;
}

- (id)init
{
	if (!(self = [super init]))
		return nil;
	
	_standardInput = [NSPipe pipe];
	_standardOutput = [NSPipe pipe];
	_standardError = [NSPipe pipe];
	
	_ngspiceTask = [[NSTask alloc] init];
	
	_ngspiceTask.launchPath = @"/Users/firelizzard/.ports/bin/ngspice";
	_ngspiceTask.arguments = @[@"-p"];
	_ngspiceTask.standardInput = _standardInput;
	_ngspiceTask.standardOutput = _standardOutput;
	_ngspiceTask.standardError = _standardError;
	
	_data = @{}.mutableCopy;
	_error = @{}.mutableCopy;
	
	NSFileHandle * fh = _standardOutput.fileHandleForWriting;
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(readData:)
											   name:NSFileHandleReadCompletionNotification
											 object:fh];
	[fh readInBackgroundAndNotify];
	
	fh = _standardOutput.fileHandleForWriting;
	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(readError:)
											   name:NSFileHandleReadCompletionNotification
											 object:fh];
	[fh readInBackgroundAndNotify];
	
	return self;
}

- (void)dealloc
{
	_ngspiceTask = nil;
	_standardInput = nil;
	_standardOutput = nil;
	_standardError = nil;
}

- (void)launch
{
	[_ngspiceTask launch];
}

- (void)terminate
{
	[_ngspiceTask terminate];
}

- (void)run:(NSString *)cmd
{
	[[_standardInput fileHandleForWriting] writeData:[[cmd stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData *)popData
{
	id data = nil;
	if (!_data.count)
		goto done;
	
	data = _data.lastObject;
	[_data removeLastObject];
	
done:
	return data;
}

- (NSData *)popError
{
	id error = nil;
	if (!_error.count)
		goto done;
	
	error = _error.lastObject;
	[_error removeLastObject];
	
done:
	return error;
}

- (void)readData:(NSNotification *)note
{
	[_data addObject:note.userInfo[NSFileHandleNotificationDataItem]];
}

- (void)readError:(NSNotification *)note
{
	[_error addObject:note.userInfo[NSFileHandleNotificationDataItem]];
}

@end
