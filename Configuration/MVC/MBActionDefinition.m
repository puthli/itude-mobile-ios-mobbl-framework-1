//
//  MBActionDefinition.m
//  Core
//
//  Created by Robert Meijer on 5/12/10.
//  Copyright 2010 Itude. All rights reserved.
//

#import "MBActionDefinition.h"

@implementation MBActionDefinition

@synthesize className = _className;

- (void) dealloc
{
	[_className release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Action name='%@' className='%@'/>\n", level, "", _name, _className];	
	return result;
}

@end
