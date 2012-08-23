//
//  MBProperties.h
//  Core
//
//  Created by Wido on 6/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPropertiesConstants.h"
#import "MBDocument.h"

/** class to retrieve application wide properties.
 * the properties are stored in a file applicationproperties.xmlx
 */
@interface MBProperties : NSObject {
    @private
    MBDocument *_propertiesDoc;
    NSMutableDictionary *_propertiesCache;
    NSMutableDictionary *_systemPropertiesCache;
}

/**
 * Returns the the ApplicationProperty value for the given key
 * @param key = The key of the ApplicationProperty
 * @return String with the value of the ApplicationProperty. Returns nil if the key is not found
 * @note Each value is cached for each application lifecycle
 */ 
+(NSString*) valueForProperty:(NSString*) key;

/**
 * Returns the SystemProperty value for the given key in the file 
 * @param key = The key of the SystemProperty
 * @return String with the value of the SystemProperty. Returns nil if the key is not found
 * @note Each value is cached for each application lifecycle
 */
+(NSString*) valueForSystemProperty:(NSString*) key;

@end
