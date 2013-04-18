//
//  MBScriptService.h
//  Core
//
//  Created by Wido on 16-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


/** Service class for evaluating javascript expressions. */
@interface MBScriptService : NSObject {

	@private
	UIWebView *_webView;
}
/// @name Getting a service instance
/** The shared instance */
+(MBScriptService *) sharedInstance;

/// @name Evaluating expressions
/** Evalaluates javascript expressions
 @discussion Caches the expression for performance.
 @throws Throws an NSException with name @"ScriptError" when the evaluation fails.
 @param expression The expressions that should be evaluated
 @return Returns the evaluated expression
 */
-(NSString*) evaluate:(NSString*) expression;

@end
