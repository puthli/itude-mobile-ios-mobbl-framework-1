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
#import "MBPanelDefinition.h"

@implementation MBPanelDefinition

@synthesize type = _type;
@synthesize style = _style;
@synthesize title = _title;
@synthesize titlePath = _titlePath;
@synthesize children = _children;
@synthesize width = _width;
@synthesize height = _height;
@synthesize zoomable = _zoomable;
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
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Panel width='%i' height='%i' type='%@'%@%@%@%@%@%@>\n", level, "", _width, _height, _type,
							   [self attributeAsXml:@"title" withValue:_title],
							   [self attributeAsXml:@"titlePath" withValue:_titlePath],
							   [self attributeAsXml:@"style" withValue:_style],
                               [self booleanAsXml:@"zoomable" withValue:_zoomable],
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
