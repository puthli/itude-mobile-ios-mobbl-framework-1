//
//  MBLanguageService.h
//  Core
//
//  Created by Wido on 11-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


#define MBLocalizedString(key) \
[[MBLocalizationService sharedInstance] textForKey:key]
#define MBLocalizedStringWithArgs(key, ...) \
[[MBLocalizationService sharedInstance] textForKey:key withArguments: __VA_ARGS__]

// Added for optimization. Is used in the framework for parsing documents. Logging when parsing documents is useless in most cases. This call never prints the "no translation found" message to the log. Logging is verry costly.
#define MBLocalizedStringWithoutLoggingWarnings(key) \
[[MBLocalizationService sharedInstance] textForKey:key logWarnings:NO]

@interface MBLocalizationService : NSObject {
	NSMutableDictionary *_languages; // Dictionary of Dictionaries (language code -> (key -> value))
	NSMutableDictionary *_currentDictionary; // Added for optimization. 
	NSString *_currentLanguage;
}

@property (nonatomic, retain) NSString *currentLanguage;

+ (MBLocalizationService *) sharedInstance;

-(NSString*) textForKey:(NSString*) key;
-(NSString*) textForKey:(NSString*) key logWarnings:(BOOL)logWarnings;
-(NSString*) textForKey:(NSString*) key forLanguageCode:(NSString *)languageCode logWarnings:(BOOL)logWarnings;
-(NSString*) textForKey:(NSString*) key withArguments:(id) argument, ...;
-(NSString*) localeCode;

@end
