//
//  MBResourceConfiguration.h
//  Core
//
//  Created by Wido on 1-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

@class MBResourceDefinition;
@class MBBundleDefinition;

@interface MBResourceConfiguration : NSObject {
	NSMutableDictionary *_resources;
	NSMutableArray *_bundles;
}

- (void) addResource:(MBResourceDefinition *)definition;
- (void) addBundle:(MBBundleDefinition *)bundle;
- (MBResourceDefinition *)getResourceWithID:(NSString *)getResourceWithID;
- (NSArray*) bundlesForLanguageCode:(NSString*) languageCode;

@end
