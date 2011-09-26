//
//  LocaleDutchLocale.m
//  Core
//
//  Created by Daniel Salber on 7/27/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


#import "LocaleUtilities.h"
#import "MBProperties.h"
#import "MBLocalizationService.h"

@implementation NSLocale (DutchLocale)

- (NSString *)getDecimalSeparator
{
	id result = nil;
	
	NSString *localeCode = [[MBLocalizationService sharedInstance] localeCode];
	
	//NSString *localeSettings = [MBProperties valueForProperty:@"localeSettings"];
	if ([localeCode isEqualToString:LOCALECODEDUTCH]) result = @",";
	// Use phone settings by default
	else result = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];

	return result;
}

- (NSString *)getGroupingSeparator
{
	id result = nil;
	
	NSString *localeCode = [[MBLocalizationService sharedInstance] localeCode];
	//NSString *localeSettings = [MBProperties valueForProperty:@"localeSettings"];
	if ([localeCode isEqualToString:LOCALECODEDUTCH]) result = @".";
	// Use phone settings by default
	else result = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
	
	return result;
}


@end
