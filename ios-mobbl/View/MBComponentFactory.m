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

#import "MBComponentFactory.h"
#import "MBComponent.h"
#import "MBDefinition.h"
#import "MBPanelDefinition.h"
#import "MBPanel.h"
#import "MBForEachDefinition.h"
#import "MBForEach.h"
#import "MBFieldDefinition.h"
#import "MBField.h"
#import "MBDocument.h"


@implementation MBComponentFactory

// This is an internal utility class; not meant to be extended or modified by applications
+(MBComponent*) componentFromDefinition: (MBDefinition*) definition document: (MBDocument*) document parent:(MBComponentContainer *) parent {
	
	MBComponent *result = nil;
	
	if([definition isKindOfClass: [MBPanelDefinition class]]) {
		result = [[MBPanel alloc] initWithDefinition: definition document: document parent: parent];
	} else if([definition isKindOfClass: [MBForEachDefinition class]]) {
		result =  [[MBForEach alloc] initWithDefinition: definition document: document parent: parent];
	} else if([definition isKindOfClass: [MBFieldDefinition class]]) {
		result =  [[MBField alloc] initWithDefinition: definition document: document parent: parent];
	} else {
		NSString *msg = [NSString stringWithFormat:@"Unsupported child type: %@ in page or panel", [definition class]];
		@throw [[[NSException alloc] initWithName:@"InvalidComponentType" reason: msg userInfo:nil] autorelease];
	}
	
	return [result autorelease];
}

@end
