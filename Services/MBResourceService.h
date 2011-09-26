//
//  MBResourceService.h
//  Core
//
//  Created by Wido on 1-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBResourceConfiguration.h"

#define RESOURCE_CONFIG_FILE_NAME @"resources"

@interface MBResourceService : NSObject {

	MBResourceConfiguration *_config;
	
}

@property (nonatomic, retain) MBResourceConfiguration *config;

+ (MBResourceService *) sharedInstance;
- (NSData*) resourceByID:(NSString*) resourceId;
- (UIImage *) imageByID:(NSString*) resourceId;
- (NSData*) resourceByURL:(NSString*) urlString;
- (NSData*) resourceByURL:(NSString*) urlString cacheable:(BOOL) cacheable timeToLive:(int) ttl;
- (NSArray*) bundlesForLanguageCode:(NSString*) languageCode;

@end
