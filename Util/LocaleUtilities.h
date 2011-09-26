//
//  LocaleDutchLocale.h
//  Core
//
//  Created by Daniel Salber on 7/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


// A subclass of NSLocale that forces Dutch decimal and grouping separators


#define LOCALECODEDUTCH @"nl_NL"

@interface NSLocale (DutchLocale) 

- (NSString *)getDecimalSeparator;
- (NSString *)getGroupingSeparator;



@end
