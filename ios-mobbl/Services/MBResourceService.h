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

/// @name Getting a service instance
/** The shared instance */
+ (MBResourceService *) sharedInstance;


/// @name Getting resources 

/** Returns a NSData object for a file based resource 
 * @param resourceId the ID for the resource
 */
- (NSData*) resourceByID:(NSString*) resourceId;

/** Returns a UIImage object for a file based resource
 * @param resourceId the ID for the resource
 */
- (UIImage *) imageByID:(NSString*) resourceId;

/** Plays an audio file for a file based resource
 * @param resourceId the ID for the resource
 */
- (void)playAudioByID:(NSString*) resourceId;

/** Returns a NSData object ath the location of the urlString without caching. This can be a network or a local resource.
 * @param urlString The url to the resource (e.g. "https://athena.itude.com/imageGallery.xml" or "file://image.jpg")
 */
- (NSData*) resourceByURL:(NSString*) urlString;

/** Returns a NSData object at the location of the urlString. This can be a network or a local resource.
 @param urlString The url to the resource (e.g. "https://athena.itude.com/imageGallery.xml" "file://image.png")
 @param cacheable set to TRUE to enable caching
 @param ttl determines the time to live when cacheable is TRUE
 */
- (NSData*) resourceByURL:(NSString*) urlString cacheable:(BOOL) cacheable timeToLive:(int) ttl;

/** The text files (texts_nl.xmlx etc) containing localization strings
 * @return Returns an NSArray of NSDictionaries containing the localized values that are stored the language files (e.g. 'texts-en.xmlx')
 * @param languageCode used to determine the localized values 
 */
- (NSArray*) bundlesForLanguageCode:(NSString*) languageCode;

@end
