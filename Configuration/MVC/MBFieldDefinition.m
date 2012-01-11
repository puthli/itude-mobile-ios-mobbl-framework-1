//
//  MBFieldDefinition.m
//  Core
//
//  Created by Mark on 4/29/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBFieldDefinition.h"
#import "MBDomainDefinition.h"
#import "MBMetadataService.h"

@implementation MBFieldDefinition

@synthesize label = _label;
@synthesize path = _path;
@synthesize style = _style;
@synthesize text = _text;
@synthesize outcomeName = _outcomeName;
@synthesize displayType = _displayType;
@synthesize dataType = _dataType;
@synthesize required = _required;
@synthesize width = _width;
@synthesize height = _height;
@synthesize formatMask = _formatMask;
@synthesize alignment = _alignment;
@synthesize valueIfNil = _valueIfNil;
@synthesize hidden = _hidden;
@synthesize custom1 = _custom1;
@synthesize custom2 = _custom2;
@synthesize custom3 = _custom3;

- (id) init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}

- (void) dealloc
{
	[_label release];
	[_path release];
	[_style release];
	[_text release];
	[_required release];
	[_hidden release];
	[_outcomeName release];
	[_displayType release];
	[_dataType release];
	[_width release];
	[_height release];
	[_formatMask release];
	[_alignment release];
	[_valueIfNil release];
	[_custom1 release];
	[_custom2 release];
	[_custom3 release];
	 
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	
	NSString *bodyText = nil;
	if(![_text isEqualToString:@""]) bodyText = _text;
	
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Field%@%@%@%@%@%@%@%@%@%@%@%@", level, "", 
							   [self attributeAsXml:@"label" withValue:_label],
							   [self attributeAsXml:@"path" withValue:_path],
							   [self attributeAsXml:@"type" withValue:_displayType],
							   [self attributeAsXml:@"dataType" withValue:_dataType],
							   [self attributeAsXml:@"outcome" withValue:_outcomeName],
							   [self attributeAsXml:@"formatMask" withValue:_formatMask],
							   [self attributeAsXml:@"alignment" withValue:_alignment],
							   [self attributeAsXml:@"valueIfNil" withValue:_alignment],
							   [self attributeAsXml:@"width" withValue:_width],
							   [self attributeAsXml:@"height" withValue:_height],
							   [self attributeAsXml:@"hidden" withValue:_hidden],
							   [self attributeAsXml:@"required" withValue:_required]];

	if(bodyText != nil) 
	{
		[result appendString:@">"];
		[result appendString:bodyText];
		[result appendString:@"</Field>\n"];
	}
	else [result appendString:@"/>\n"];
	return result;
}

@end
