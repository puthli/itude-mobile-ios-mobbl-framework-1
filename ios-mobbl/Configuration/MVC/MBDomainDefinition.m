//
//  MBDomainDefinition.m
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

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
