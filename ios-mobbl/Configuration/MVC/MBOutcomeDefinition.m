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

#import "MBOutcomeDefinition.h"

@interface MBOutcomeDefinition () {
	NSString *_origin;
	NSString *_action;
	NSString *_dialog;
    NSString *_pageStackName;
	NSString *_displayMode;
    NSString *_transitionStyle;
	NSString *_preCondition;
    NSString *_processingMessage;
	BOOL _persist;
	BOOL _transferDocument;
	BOOL _noBackgroundProcessing;
}
@end

@implementation MBOutcomeDefinition

@synthesize origin = _origin;
@synthesize action = _action;
@synthesize dialog = _dialog;
@synthesize pageStackName = _pageStackName;
@synthesize displayMode = _displayMode;
@synthesize transitionStyle = _transitionStyle;
@synthesize preCondition = _preCondition;
@synthesize processingMessage = _processingMessage;
@synthesize persist = _persist;
@synthesize transferDocument = _transferDocument;
@synthesize noBackgroundProcessing = _noBackgroundProcessing;

- (void) dealloc
{
	[_origin release];
	[_action release];
	[_dialog release];
    [_pageStackName release];
    [_displayMode release];
    [_transitionStyle release];
    [_preCondition release];
    [_processingMessage release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat:@"%*s<Outcome origin='%@' name='%@' action='%@' transferDocument='%@' persist='%@' noBackgroundProcessing='%@'%@%@%@%@%@%@/>\n", level, "", 
							   _origin, _name, _action, _transferDocument?@"TRUE":@"FALSE", _persist?@"TRUE":@"FALSE",_noBackgroundProcessing?@"TRUE":@"FALSE",
							   [self attributeAsXml:@"dialog" withValue:self.dialog],
                               [self attributeAsXml:@"pageStack" withValue:self.pageStackName],
                               [self attributeAsXml:@"preCondition" withValue:_preCondition],
                               [self attributeAsXml:@"displayMode" withValue:_displayMode], 
                               [self attributeAsXml:@"transitionStyle" withValue:_transitionStyle],
                               [self attributeAsXml:@"processingMessage" withValue:_processingMessage]];
	return result;
}

@end
