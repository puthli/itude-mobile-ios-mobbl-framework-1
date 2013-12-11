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

#import "MBPageStackDefinition.h"

@interface MBPageStackDefinition () {
	NSString *_title;
}
@end


@implementation MBPageStackDefinition

@synthesize title = _title;

- (void) dealloc
{
	[_title release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<PageStack %@%@/>\n", level, "",
							   [self attributeAsXml:@"name" withValue:self.name],
                               [self attributeAsXml:@"title" withValue:self.title]];
	return result;
}

-(void) validateDefinition {
	if(self.name.length == 0) {
        @throw [NSException exceptionWithName: @"InvalidPageStackDefinition" reason: [NSString stringWithFormat: @"no name set for pageStack"] userInfo:nil];
    }
}

@end
