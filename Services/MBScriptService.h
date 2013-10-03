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
