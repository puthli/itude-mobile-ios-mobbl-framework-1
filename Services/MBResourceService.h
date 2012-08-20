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

/// @name Getting a service instance
/** The shared instance */
+ (MBResourceService *) sharedInstance;


/// @name Getting resources 

/** Returns a NSData object for the resourceId 
 @param resourceId the ID for the resource
 */
- (NSData*) resourceByID:(NSString*) resourceId;

/** Returns a UIImage object for the resourceId 
 @param resourceId the ID for the resource
 */
- (UIImage *) imageByID:(NSString*) resourceId;

/** Returns a NSData object for the urlString without caching */
- (NSData*) resourceByURL:(NSString*) urlString;

/** Returns a NSData object for the urlString 
 @param urlString the url to the resource (e.g. "file://image.png")
 @param cacheable set to TRUE to enable caching
 @param ttl determines the time to live when cacheable is TRUE
 */
- (NSData*) resourceByURL:(NSString*) urlString cacheable:(BOOL) cacheable timeToLive:(int) ttl;

/** Returns an NSArray of NSDictionaries containing the localized values that are stored the language files (e.g. 'texts-en')
 @param languageCode used to determine the localized values 
 */
- (NSArray*) bundlesForLanguageCode:(NSString*) languageCode;

@end
