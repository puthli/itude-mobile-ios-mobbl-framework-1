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

#import "MBDomainDefinition.h"

@implementation MBDomainDefinition

@synthesize type = _type;
@synthesize maxLength = _maxLength;
@synthesize domainValidators = _validators;

- (id) init {
	if (self = [super init])
	{
		_validators = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[_type release];
	[_maxLength release];
	[_validators release];

	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Domain name='%@' type='%@'%@>\n", level, "", _name, _type, [self attributeAsXml:@"maxLength" withValue: _maxLength]];
	for (MBDomainValidatorDefinition* vld in _validators)
		[result appendString:[vld asXmlWithLevel:level+2]];
	[result appendFormat:@"%*s</Domain>\n", level, ""];
	return result;
}

- (void) addValidator:(MBDomainValidatorDefinition*)validator {
	[_validators addObject:validator];
}

- (void) removeValidatorAtIndex:(NSUInteger)index {
	[_validators removeObjectAtIndex:index];
}

@end
