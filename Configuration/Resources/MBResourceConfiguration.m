//
//  MBResourceConfiguration.m
//  Core
//
//  Created by Wido on 1-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBResourceConfiguration.h"
#import "MBResourceDefinition.h"
#import "MBBundleDefinition.h"

@implementation MBResourceConfiguration

- (id) init
{
	self = [super init];
	if (self != nil) {
		_resources = [NSMutableDictionary new];
		_bundles = [NSMutableArray new];
	}
	return self;
}

- (void) addResource:(MBResourceDefinition *)definition {
	[_resources setValue:definition forKey:definition.resourceId];
}

- (MBResourceDefinition *)getResourceWithID:(NSString *)resourceId {
	return (MBResourceDefinition*)[_resources valueForKey:resourceId];
}

- (void) addBundle:(MBBundleDefinition *)bundle {
	[_bundles addObject:bundle];
}

- (NSArray*) bundlesForLanguageCode:(NSString*) languageCode {
	NSMutableArray *subset = [[NSMutableArray new] autorelease];
	for(MBBundleDefinition *def in _bundles) {
		if([def.languageCode isEqualToString:languageCode]) [subset	addObject:def];
	}
	return subset;
}

-(void) validateDefinition {
	
}

- (void) dealloc
{
	[_resources release];
	[super dealloc];
}

@end
