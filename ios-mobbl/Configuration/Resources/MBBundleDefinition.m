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

#import "MBBundleDefinition.h"


@implementation MBBundleDefinition

@synthesize languageCode = _languageCode;
@synthesize url = _url;


- (void) dealloc
{
	[_url release];
	[_languageCode release];
	[super dealloc];
}

-(void) validateDefinition {
	if(_languageCode == nil)  @throw [NSException exceptionWithName: @"InvalidBundleDefinition" reason: [NSString stringWithFormat: @"no languageCode set for bundle %@", [self asXmlWithLevel:0]] userInfo:nil];
	if(_url == nil) @throw [NSException exceptionWithName: @"InvalidBundleDefinition" reason: [NSString stringWithFormat: @"no url set for bundle %@", [self asXmlWithLevel:0]] userInfo:nil];
}

@end
