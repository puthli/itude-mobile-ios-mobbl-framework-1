/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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

#import "MBAlertDefinition.h"

@implementation MBAlertDefinition


- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Alert name='%@' document='%@'%@>\n", level, "",  _name, _documentName, [self attributeAsXml:@"title" withValue:_title]];
	for (MBFieldDefinition* child in _children) {
		[result appendString: [child asXmlWithLevel:level+2]];
    }
	[result appendFormat:@"%*s</Alert>\n", level, ""];
    
	return result;
}

-(void) validateDefinition {
	if(_name == nil) {
        @throw [NSException exceptionWithName: @"InvalidAlertDefinition" reason: [NSString stringWithFormat: @"no name set for alert %@", [self asXmlWithLevel:0]] userInfo:nil];
    }
}

@end
