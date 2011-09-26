//
//  MBDomainValidatorDefinition.m
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

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
