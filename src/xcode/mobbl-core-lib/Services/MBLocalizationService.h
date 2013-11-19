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

/** Returns a localized value for a key */
#define MBLocalizedString(key) \
[[MBLocalizationService sharedInstance] textForKey:key]

/** Should return a localized value for a key using arguments */
#define MBLocalizedStringWithArgs(key, ...) \
[[MBLocalizationService sharedInstance] textForKey:key withArguments: __VA_ARGS__]

/** Returns a localized value for a key witout logging warnings when the key is not found. 
 @discussion Use this macro when you need an optimzed localized key. Logging is costly and can reduce performance. This method is used by the framework while parsing documents.
 */
#define MBLocalizedStringWithoutLoggingWarnings(key) \
[[MBLocalizationService sharedInstance] textForKey:key logWarnings:NO]


/** Central service for localizing strings
 * All labels and values are passed through the MBLocalizationService by the MOBBL framework. 
 * Simply add a texts-[country code].xmlx (e.g. texts-en.xmlx) file and set the country code on the MBLocalisation service for a new language.
 */
@interface MBLocalizationService : NSObject {
	NSMutableDictionary *_languages; // Dictionary of Dictionaries (language code -> (key -> value))
	NSMutableDictionary *_currentDictionary; // Added for optimization. 
	NSString *_currentLanguage;
}

/// @name Properties
/** Contains the current language code. */
@property (nonatomic, retain) NSString *currentLanguage;

/// @name Getting a service instance
/** The shared instance */
+ (MBLocalizationService *) sharedInstance;

/// @name Getting localized translations
/** See [MBLocalizationService textForKey:forLanguageCode:logWarnings:] */
-(NSString*) textForKey:(NSString*) key;

/** See [MBLocalizationService textForKey:forLanguageCode:logWarnings:] */
-(NSString*) textForKey:(NSString*) key logWarnings:(BOOL)logWarnings;

/** Returns a value for a key in a specific language. The value should appear in the translation file (e.g. 'texts-en.xml')
 @param key key that is used to find the value in the language file
 @param languageCode language code that the where the key should be searched in. 
 @param logWarnings boolean property that indicates if a warning should be logged when the key is not found
 */
-(NSString*) textForKey:(NSString*) key forLanguageCode:(NSString *)languageCode logWarnings:(BOOL)logWarnings;

/** Should return a value for a key in a specific language, using arguments as parameters. NOTE: This method currently does not work as espected */
-(NSString*) textForKey:(NSString*) key withArguments:(id) argument, ...;

/** Returns the current localCode (e.g. 'nl_NL') */
-(NSString*) localeCode;

@end
