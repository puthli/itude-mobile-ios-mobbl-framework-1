//
//  MBResultListener.m
//  Core
//
//  Created by Wido on 6/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

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
