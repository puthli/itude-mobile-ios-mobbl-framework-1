//
//  LocaleDutchLocale.h
//  Core
//
//  Created by Daniel Salber on 7/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


// A subclass of NSLocale that forces Dutch decimal and grouping separators


#define LOCALECODEDUTCH   @"nl_NL" // A string for the dutch Locale
#define LOCALECODEITALIAN @"it_IT" // A string for the italian Locale

@interface NSLocale (DutchLocale) 

/**
 * Returns the decimal seperator depending on the device locale settings.
 * @return String with a decimal seperator character.
 * @note Returns a , (comma) when the localeCode is dutch 
 */
- (NSString *)getDecimalSeparator;


/** 
 * Returns a grouping seperator depending on the device locale settings. 
 * @return String with a grouping seperator character.
 * @note Returns a . (dot) when the localeCode is dutch 
 */
- (NSString *)getGroupingSeparator;


@end
