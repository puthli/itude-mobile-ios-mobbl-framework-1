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

#import "MBDomainValidatorDefinition.h"


@implementation MBDomainValidatorDefinition

@synthesize title = _title;
@synthesize value = _value;
@synthesize lowerBound = _lowerBound;
@synthesize upperBound = _upperBound;

- (void) dealloc
{
	[_title release];
	[_value release];
	[super dealloc];
}


- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<DomainValidator%@%@%@%@/>\n", level, "",
							   [self attributeAsXml:@"title" withValue:_title],
							   [self attributeAsXml:@"value" withValue:_value],
							   [self attributeAsXml:@"lowerBound" withValue:_lowerBound],
							   [self attributeAsXml:@"upperBound" withValue:_upperBound]
							   ];
	return result;
}

@end
