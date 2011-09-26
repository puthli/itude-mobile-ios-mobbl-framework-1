//
//  MBScriptService.m
//  Core
//
//  Created by Wido on 16-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBScriptService.h"

static MBScriptService *_instance = nil;

@implementation MBScriptService

+(MBScriptService *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		_webView = [[UIWebView alloc] init];
		[_webView loadHTMLString:@"" baseURL:nil];
	}
	return self;
}

- (void) dealloc
{
	[_webView release];
	[super dealloc];
}

-(NSString*) evaluate:(NSString*) expression {
	NSString *ERROR_MARKER = @"SCRIPT_ERROR: ";
	
	NSString *stub = [NSString stringWithFormat:@"function x(){ try { return %@;} catch(e) { return '%@'+e;}} x();", expression, ERROR_MARKER];
	NSString *result = [_webView stringByEvaluatingJavaScriptFromString:stub];	
	if([result hasPrefix:ERROR_MARKER]) { 
		NSString *msg = [NSString stringWithFormat:@"Error evaluating expression <%@>: %@", expression, [result substringFromIndex:[ERROR_MARKER length]]];
		@throw [NSException exceptionWithName:@"ScriptError" reason:msg userInfo:nil];
	}
	return result;
}


@end
