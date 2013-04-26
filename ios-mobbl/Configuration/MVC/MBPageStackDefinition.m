//
//  MBPageStackDefinition.m
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPageStackDefinition.h"

@interface MBPageStackDefinition () {
	NSString *_title;
}
@end


@implementation MBPageStackDefinition

@synthesize title = _title;

- (void) dealloc
{
	[_title release];
	[super dealloc];
}

- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<PageStack %@%@/>\n", level, "",
							   [self attributeAsXml:@"name" withValue:self.name],
                               [self attributeAsXml:@"title" withValue:self.title]];
	return result;
}

-(void) validateDefinition {
	if(self.name.length == 0) {
        @throw [NSException exceptionWithName: @"InvalidPageStackDefinition" reason: [NSString stringWithFormat: @"no name set for pageStack"] userInfo:nil];
    }
}

@end
