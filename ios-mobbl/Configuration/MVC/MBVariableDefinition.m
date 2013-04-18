//
//  MBVariable.m
//  Core
//
//  Created by Wido on 6/3/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBVariableDefinition.h"


@implementation MBVariableDefinition

@synthesize expression = _expression;

- (id) init
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void) dealloc
{
    [_expression release];
    [super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Variable name='%@' expression='%@'/>\n", level, "", _name, _expression];	
	return result;
}

@end
