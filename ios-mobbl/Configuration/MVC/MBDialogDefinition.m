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
#import "MBPageStackDefinition.h"

@interface MBDialogDefinition () {
	NSString *_title;
	NSString *_mode;
	NSString *_icon;
    NSString *_showAs;
    NSString *_contentType;
    NSString *_decorator;
    NSString *_stackStrategy;
    BOOL _closable;
    NSMutableArray *_pageStacks;
}

@end

@implementation MBDialogDefinition

@synthesize title = _title;
@synthesize mode = _mode;
@synthesize iconName = _icon;
@synthesize showAs = _showAs;
@synthesize contentType = _contentType;
@synthesize decorator = _decorator;
@synthesize stackStrategy = _stackStrategy;
@synthesize pageStacks = _pageStacks;
@synthesize closable = _closable;


- (id) init {
	if (self = [super init]) {
        self.pageStacks = [[NSMutableArray new] autorelease];
	}
	return self;
}


- (void) dealloc {
	[_title release];
	[_mode release];
	[_icon release];
    [_showAs release];
    [_contentType release];
    [_decorator release];
    [_stackStrategy release];
	[_pageStacks release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Dialog %@%@%@%@%@%@%@%@%@/>\n", level, "",
							   [self attributeAsXml:@"name" withValue:self.name],
                               [self attributeAsXml:@"mode" withValue:self.mode],
							   [self attributeAsXml:@"title" withValue:self.title],
							   [self attributeAsXml:@"icon" withValue:self.iconName],
                               [self attributeAsXml:@"showAs" withValue:self.showAs],
                               [self attributeAsXml:@"contentType" withValue:self.contentType],
                               [self attributeAsXml:@"decorator" withValue:self.decorator],
                               [self attributeAsXml:@"stackStrategy" withValue:self.stackStrategy],
                               [self booleanAsXml:@"closable" withValue:self.closable]];
	
	for (MBPageStackDefinition *definition in self.pageStacks) {
		[result appendString:[definition asXmlWithLevel:level+2]];
	}

	[result appendFormat:@"%*s</Dialog>\n", level, ""];
	return result;
}

- (void) validateDefinition {
	if(_name == nil) @throw [NSException exceptionWithName: @"InvalidDialogDefinition" reason: [NSString stringWithFormat: @"no name set for dialog"] userInfo:nil];
}


- (void) addPageStack:(MBPageStackDefinition *) child {
    [self.pageStacks addObject:child];
}


@end
