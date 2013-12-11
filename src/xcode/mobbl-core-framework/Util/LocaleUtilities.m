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
