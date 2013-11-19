/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
