//
//  MBContainerDefinition.m
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBPanelDefinition.h"

@implementation MBPanelDefinition

@synthesize type = _type;
@synthesize style = _style;
@synthesize title = _title;
@synthesize titlePath = _titlePath;
@synthesize children = _children;
@synthesize width = _width;
@synthesize height = _height;
@synthesize outcomeName = _outcomeName;
@synthesize path = _path;

- (id) init {
	if (self = [super init]) {
		_children = [NSMutableArray new];
	}
	return self;
}

- (void) dealloc {	
	[_type release];
	[_style release];
	[_title release];
	[_titlePath release];
    [_outcomeName release];
    [_path release];
	[_children release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Panel width='%i' height='%i' type='%@'%@%@%@%@%@>\n", level, "", _width, _height, _type,
							   [self attributeAsXml:@"title" withValue:_title],
							   [self attributeAsXml:@"titlePath" withValue:_titlePath],
							   [self attributeAsXml:@"style" withValue:_style],
                               [self attributeAsXml:@"outcomeName" withValue:_outcomeName], 
                               [self attributeAsXml:@"path" withValue:_path]];
	for (MBDefinition* child in _children)
		[result appendString:[child asXmlWithLevel:level+2]];
	[result appendFormat:@"%*s</Panel>\n", level, ""];
	return result;
}

- (void) addChild:(MBDefinition*)child {
	[_children addObject:child];
}

@end
