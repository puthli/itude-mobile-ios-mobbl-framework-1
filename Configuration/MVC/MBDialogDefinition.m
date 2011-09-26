//
//  MBDialogDefinition.m
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDialogDefinition.h"


@implementation MBDialogDefinition

@synthesize title = _title;
@synthesize mode = _mode;
@synthesize icon = _icon;
@synthesize groupName = _groupName;
@synthesize position = _position;

- (void) dealloc
{
	[_title release];
	[_mode release];
	[_icon release];
	[_groupName release];
	[_position release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Dialog name='%@'%@%@%@%@%@/>\n", level, "",  _name, 
							   [self attributeAsXml:@"mode" withValue:_mode],
							   [self attributeAsXml:@"title" withValue:_title],
							   [self attributeAsXml:@"icon" withValue:_icon],
							   [self attributeAsXml:@"groupName" withValue:_groupName],
							   [self attributeAsXml:@"position" withValue:_position]];
	return result;
}

-(void) validateDefinition {
	if(_name == nil) @throw [NSException exceptionWithName: @"InvalidDialogDefinition" reason: [NSString stringWithFormat: @"no name set for dialog"] userInfo:nil];
	if (_groupName!=nil && _position==nil) @throw [NSException exceptionWithName: @"InvalidDialogDefinition" reason: [NSString stringWithFormat: @"dialog '%@' is nested in a dialogGroup '%@', but has no position attribute. Position should be 'LEFT' or 'RIGHT'",_name,_groupName] userInfo:nil];
}

@end
