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

#import "MBResultListenerDefinition.h"
#import "StringUtilities.h"

@implementation MBResultListenerDefinition

@synthesize matchExpression = _matchExpression;
@synthesize matchParts = _matchParts;

- (void) dealloc
{
	[_matchExpression release];
	[_name release];
	[_matchParts release];
	[super dealloc];
}

- (BOOL) matches:(NSString*) result {
	BOOL match = NO;	

	
	if(self.matchParts == nil) {
		self.matchParts = [_matchExpression componentsSeparatedByString:@"*"];
	}

	NSRange range;
	range.location = 0;
	range.length = [result length];
	
	for(int i=0; range.length != 0 && i<_matchParts.count; i++) {
		NSString *matchPart = [_matchParts objectAtIndex:i];
		if ([matchPart length]>0) {
			NSRange searchRange;
			searchRange.location = range.location;
			searchRange.length = [result length] - searchRange.location;
			range = [result rangeOfString: matchPart 
								options: NSLiteralSearch 
								  range: searchRange];
			if(range.length)
			{
				match=YES;
				// continue search
				range.location += range.length;
			}
			else{
				// no match, abort
				match = NO;
				break;
			}
		}
	}
	return match;
}

@end
