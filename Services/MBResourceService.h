//
//  MBResourceService.h
//  Core
//
//  Created by Wido on 1-6-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBResourceConfiguration.h"

#define RESOURCE_CONFIG_FILE_NAME @"resources"
/** Service for accessing resources over the network or on the file system.
 *
 * retrieves images or files and caches them
 */
@interface MBResourceService : NSObject {

	MBResourceConfiguration *_config;
	
}

@property (nonatomic, retain) MBResourceConfiguration *config;

/** the shared instance */
+ (MBResourceService *) sharedInstance;
/** file based resources */
- (NSData*) resourceByID:(NSString*) resourceId;
- (UIImage *) imageByID:(NSString*) resourceId;
/** network based resources */
- (NSData*) resourceByURL:(NSString*) urlString;
- (NSData*) resourceByURL:(NSString*) urlString cacheable:(BOOL) cacheable timeToLive:(int) ttl;
/** The text files (texts_nl.xmlx etc) containing localization strings */
- (NSArray*) bundlesForLanguageCode:(NSString*) languageCode;

@end
