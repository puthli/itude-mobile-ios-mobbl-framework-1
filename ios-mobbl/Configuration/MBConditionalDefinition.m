//
//  MBConditionalDefinition.m
//  Core
//
//  Created by Wido on 16-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

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
