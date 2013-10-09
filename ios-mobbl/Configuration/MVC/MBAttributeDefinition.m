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

#import "MBAttributeDefinition.h"
#import "MBDomainDefinition.h"
#import "MBMetadataService.h"

@implementation MBAttributeDefinition

@synthesize type = _type;
@synthesize required = _required;
@synthesize defaultValue = _defaultValue;

- (id) init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}


- (void) dealloc
{
	[_type release];
	[_defaultValue release];
	[_dataType release];
	 
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Attribute name='%@' type='%@' required='%@'%@/>\n", level, "", 
							   _name, _type, _required?@"TRUE":@"FALSE",
							   [self attributeAsXml:@"defaultValue" withValue:_defaultValue]];	
	return result;
}

- (MBDomainDefinition*) domainDefinition {
	if(_domainDefinition == nil) {
		_domainDefinition = [[MBMetadataService sharedInstance] definitionForDomainName:_type];
	}
	return _domainDefinition;
}

- (NSString*) dataType {
	if(_dataType == nil) {
		MBDomainDefinition *domDef = [[MBMetadataService sharedInstance] definitionForDomainName:_type  throwIfInvalid:(BOOL) FALSE];
		NSString *tp = domDef.type;
		if(tp == nil) tp = self.type;
		if(_dataType != tp) {
			[_dataType release];
			_dataType = [tp retain];
		}
	}
	return _dataType;
}
@end
