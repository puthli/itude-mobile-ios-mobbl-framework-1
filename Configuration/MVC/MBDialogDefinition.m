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
