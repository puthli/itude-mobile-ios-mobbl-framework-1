//
//  MBDialogGroupDefinition.m
//  Core
//
//  Created by Frank van Eenbergen on 13-10-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDialogGroupDefinition.h"
#import "MBDialogDefinition.h"


@implementation MBDialogGroupDefinition

@synthesize title = _title;
@synthesize mode = _mode;
@synthesize icon = _icon;

- (id) init {
	if (self = [super init]) {
		_children = [NSMutableDictionary new];
		_childrenSorted = [NSMutableArray new];
	}
	return self;
}


- (void) dealloc {
	[_title release];
	[_mode release];
	[_icon release];
	
	[_children release];
	[_childrenSorted release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<DialogGroup name='%@'%@%@%@/>\n", level, "",  _name, 
							   [self attributeAsXml:@"mode" withValue:_mode],
							   [self attributeAsXml:@"title" withValue:_title],
							   [self attributeAsXml:@"icon" withValue:_icon]];
	
	for (MBDialogDefinition *dialog in _childrenSorted) {
		[result appendString:[dialog asXmlWithLevel:level+2]];
	}

	[result appendFormat:@"%*s</DialogGroup>\n", level, ""];
	return result;
}

- (void) validateDefinition {
	if(_name == nil) @throw [NSException exceptionWithName: @"InvalidDialogGroupDefinition" reason: [NSString stringWithFormat: @"no name set for dialogGroup"] userInfo:nil];
}

- (NSMutableArray*) children {
	return _childrenSorted;	
}

- (void) addDialog:(MBDialogDefinition *)dialog {
	[_childrenSorted addObject:dialog];
	[_children setValue:dialog forKey:dialog.name];
}

@end
