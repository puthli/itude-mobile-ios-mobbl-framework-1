//
//  MBScriptService.m
//  Core
//
//  Created by Wido on 16-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBScriptService.h"

static MBScriptService *_instance = nil;
NSMutableDictionary *_cache = nil;

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
        _cache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[_webView release];
    [_cache release];
	[super dealloc];
}

- (NSString*) description{
    return [NSString stringWithFormat:@"MBScriptService cache contains %d objects", [_cache count]];
}

-(NSString*) evaluate:(NSString*) expression {
    
    // Escape the '\' in '\n' so that the javascript is validated properly
    NSMutableString *mutableExpression = [expression mutableCopy];
    [mutableExpression replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mutableExpression length])];
    expression = mutableExpression;
    
    // Search for cached result to improve performance
    NSString *result = [_cache objectForKey:expression];
	if (result == nil) {
        NSString *ERROR_MARKER = @"SCRIPT_ERROR: ";
        
        NSString *stub = [NSString stringWithFormat:@"function x(){ try { return %@;} catch(e) { return '%@'+e;}} x();", expression, ERROR_MARKER];
        result = [_webView stringByEvaluatingJavaScriptFromString:stub];	
        if([result hasPrefix:ERROR_MARKER]) { 
            NSString *msg = [NSString stringWithFormat:@"Error evaluating expression <%@>: %@", expression, [result substringFromIndex:[ERROR_MARKER length]]];
            @throw [NSException exceptionWithName:@"ScriptError" reason:msg userInfo:nil];
        }
        [_cache setObject:result forKey:expression];
    }
	return result;
}


@end
