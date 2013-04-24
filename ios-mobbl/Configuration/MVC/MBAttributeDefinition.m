//
//  MBAttributeDefinition.m
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

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
