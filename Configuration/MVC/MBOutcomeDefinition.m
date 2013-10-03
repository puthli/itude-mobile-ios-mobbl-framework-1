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

@implementation MBOutcomeDefinition

@synthesize origin = _origin;
@synthesize action = _action;
@synthesize dialog = _dialog;
@synthesize displayMode = _displayMode;
@synthesize transitioningStyle = _transitioningStyle;
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
