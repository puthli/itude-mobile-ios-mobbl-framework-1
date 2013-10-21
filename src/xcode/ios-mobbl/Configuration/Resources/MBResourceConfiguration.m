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

#import "MBResourceConfiguration.h"
#import "MBResourceDefinition.h"
#import "MBBundleDefinition.h"

@implementation MBResourceConfiguration

- (id) init
{
	self = [super init];
	if (self != nil) {
		_resources = [NSMutableDictionary new];
		_bundles = [NSMutableArray new];
	}
	return self;
}

- (void) addResource:(MBResourceDefinition *)definition {
	[_resources setValue:definition forKey:definition.resourceId];
}

- (MBResourceDefinition *)getResourceWithID:(NSString *)resourceId {
	return (MBResourceDefinition*)[_resources valueForKey:resourceId];
}

- (void) addBundle:(MBBundleDefinition *)bundle {
	[_bundles addObject:bundle];
}

- (NSArray*) bundlesForLanguageCode:(NSString*) languageCode {
	NSMutableArray *subset = [[NSMutableArray new] autorelease];
	for(MBBundleDefinition *def in _bundles) {
		if([def.languageCode isEqualToString:languageCode]) [subset	addObject:def];
	}
	return subset;
}

-(void) validateDefinition {
	
}

- (void) dealloc
{
	[_resources release];
	[super dealloc];
}

@end
