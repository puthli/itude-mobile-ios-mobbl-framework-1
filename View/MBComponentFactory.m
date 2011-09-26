//
//  MBComponentFactory.m
//  Core
//
//  Created by Wido on 23-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBComponentFactory.h"
#import "MBComponent.h"
#import "MBDefinition.h"
#import "MBPanelDefinition.h"
#import "MBPanel.h"
#import "MBForEachDefinition.h"
#import "MBForEach.h"
#import "MBFieldDefinition.h"
#import "MBField.h"
#import "MBDocument.h"


@implementation MBComponentFactory

// This is an internal utility class; not meant to be extended or modified by applications
+(MBComponent*) componentFromDefinition: (MBDefinition*) definition document: (MBDocument*) document parent:(MBComponentContainer *) parent {
	
	MBComponent *result = nil;
	
	if([definition isKindOfClass: [MBPanelDefinition class]]) {
		result = [[MBPanel alloc] initWithDefinition: definition document: document parent: parent];
	} else if([definition isKindOfClass: [MBForEachDefinition class]]) {
		result =  [[MBForEach alloc] initWithDefinition: definition document: document parent: parent];
	} else if([definition isKindOfClass: [MBFieldDefinition class]]) {
		result =  [[MBField alloc] initWithDefinition: definition document: document parent: parent];
	} else {
		NSString *msg = [NSString stringWithFormat:@"Unsupported child type: %@ in page or panel", [definition class]];
		@throw [[NSException alloc] initWithName:@"InvalidComponentType" reason: msg userInfo:nil];
	}
	
	return [result autorelease];
}

@end
