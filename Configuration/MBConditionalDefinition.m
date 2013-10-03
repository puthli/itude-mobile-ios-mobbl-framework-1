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
#import "MBConditionalDefinition.h"
#import "MBDocument.h"

@implementation MBConditionalDefinition

@synthesize preCondition = _preCondition;

- (void) dealloc
{
	[_preCondition release];
	[super dealloc];
}

- (BOOL) isPreConditionValid:(MBDocument*) document currentPath:(NSString*) currentPath {
	if(_preCondition == nil) return TRUE;
	
	NSString *result = [document evaluateExpression:_preCondition currentPath: currentPath];
	
	result = [result uppercaseString];
	if([@"1" isEqualToString:result] || [@"YES" isEqualToString:result] || [@"TRUE" isEqualToString:result]) return TRUE;
	if([@"0" isEqualToString:result] || [@"NO" isEqualToString:result]  || [@"FALSE" isEqualToString:result]) return FALSE;
	
	NSString *msg = [NSString stringWithFormat:@"Expression preCondition=%@ is not boolean (%@)", _preCondition, result];
	@throw [NSException exceptionWithName:@"ExpressionNotBoolean" reason:msg userInfo: nil];
}

@end
