//
//  MBNavigateDefinition.m
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBOutcomeDefinition.h"

@implementation MBOutcomeDefinition

@synthesize origin = _origin;
@synthesize action = _action;
@synthesize dialog = _dialog;
@synthesize displayMode = _displayMode;
@synthesize transitionStyle = _transitioningStyle;
@synthesize preCondition = _preCondition;
@synthesize persist = _persist;
@synthesize transferDocument = _transferDocument;
@synthesize noBackgroundProcessing = _noBackgroundProcessing;

- (void) dealloc
{
	[_origin release];
	[_action release];
	[_dialog release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat:@"%*s<Outcome origin='%@' name='%@' action='%@' transferDocument='%@' persist='%@' noBackgroundProcessing='%@'%@%@%@%@/>\n", level, "", 
							   _origin, _name, _action, _transferDocument?@"TRUE":@"FALSE", _persist?@"TRUE":@"FALSE",_noBackgroundProcessing?@"TRUE":@"FALSE",
							   [self attributeAsXml:@"dialog" withValue:_dialog],
                               [self attributeAsXml:@"preCondition" withValue:_preCondition],
                               [self attributeAsXml:@"displayMode" withValue:_displayMode], 
                               [self attributeAsXml:@"transitioningStyle" withValue:_transitioningStyle]];
	return result;
}

@end
