/*
 * (C) Copyright ItudeMobile.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
    
    // Search for cached result to improve performance
    NSString *result = [_cache objectForKey:mutableExpression];
	if (result == nil) {
        NSString *ERROR_MARKER = @"SCRIPT_ERROR: ";
        
        NSString *stub = [NSString stringWithFormat:@"function x(){ try { return %@;} catch(e) { return '%@'+e;}} x();", mutableExpression, ERROR_MARKER];
        result = [_webView stringByEvaluatingJavaScriptFromString:stub];	
        if([result hasPrefix:ERROR_MARKER]) { 
            NSString *msg = [NSString stringWithFormat:@"Error evaluating expression <%@>: %@", mutableExpression, [result substringFromIndex:[ERROR_MARKER length]]];
            @throw [NSException exceptionWithName:@"ScriptError" reason:msg userInfo:nil];
        }
        [_cache setObject:result forKey:mutableExpression];
    }
    [mutableExpression release];
	return result;
}


@end
