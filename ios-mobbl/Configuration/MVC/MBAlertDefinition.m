//
//  MBAlertDefinition.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/20/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBAlertDefinition.h"

@implementation MBAlertDefinition


- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<Alert name='%@' document='%@'%@>\n", level, "",  _name, _documentName, [self attributeAsXml:@"title" withValue:_title]];
	for (MBFieldDefinition* child in _children) {
		[result appendString: [child asXmlWithLevel:level+2]];
    }
	[result appendFormat:@"%*s</Alert>\n", level, ""];
    
	return result;
}

-(void) validateDefinition {
	if(_name == nil) {
        @throw [NSException exceptionWithName: @"InvalidAlertDefinition" reason: [NSString stringWithFormat: @"no name set for alert %@", [self asXmlWithLevel:0]] userInfo:nil];
    }
}

@end
