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

#import "MBResourceDefinition.h"


@implementation MBResourceDefinition

@synthesize resourceId = _resourceId;
@synthesize url = _url;
@synthesize cacheable = _cacheable;
@synthesize ttl = _ttl;


- (void) dealloc
{
	[_resourceId release];
	[_url release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Resource id='%@' url='%@'%@ ttl='%i'/>\n", level, "",  _resourceId, _url, _cacheable?@"TRUE":@"FALSE", _ttl];
	return result;
}

-(void) validateDefinition {
	if(_resourceId == nil)  @throw [NSException exceptionWithName: @"InvalidResourceDefinition" reason: [NSString stringWithFormat: @"no id set for resource %@", [self asXmlWithLevel:0]] userInfo:nil];
	if(_url == nil) @throw [NSException exceptionWithName: @"InvalidResourceDefinition" reason: [NSString stringWithFormat: @"no url set for resource %@", [self asXmlWithLevel:0]] userInfo:nil];
}

@end
