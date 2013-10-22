/*
 * (C) Copyright ItudeMobile.
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

#import "BinckUtilities.h"
#import "MBDocument.h"
#import "MBElement.h"


@implementation NSObject(Utilities)

-(void) setRequestParameter:(NSString *)value forKey:(NSString *)key forDocument:(MBDocument *)doc{
	MBElement *request = [doc valueForPath:@"Request[0]"];
	MBElement *parameter = [request createElementWithName:@"Parameter"];
	[parameter setValue:key forAttribute:@"key"];
	[parameter setValue:value forAttribute:@"value"];
}

@end

@implementation NSString(BinckUtilities)

- (double)doubleValueDutch {
	
	// if we have a comma, replace with a dot
	NSString *converted = [self stringByReplacingOccurrencesOfString:@"," withString:@"."];
	//	converted = [converted stringByReplacingOccurrencesOfString:@"," withString:@"."];
	return [converted doubleValue];
}

- (float)floatValueDutch {
	
	// if we have a comma, replace with a dot
	NSString *converted = [self stringByReplacingOccurrencesOfString:@"," withString:@"."];
	//	converted = [converted stringByReplacingOccurrencesOfString:@"," withString:@"."];
	return [converted floatValue];
}

- (NSString*)getCurrencyCode {
	if		([@"EUR" isEqualToString:self]) return @""	 ;
	else if ([@"fl." isEqualToString:self]) return @"fl.";
	else if ([@"NLG" isEqualToString:self]) return @"fl.";
	else if ([@"$"	 isEqualToString:self])	return @"$"	 ;
	else if ([@"USD" isEqualToString:self]) return @"$"	 ;
	else if ([@"ZAR" isEqualToString:self]) return @"ZAR";
	else if ([@"ANG" isEqualToString:self]) return @"ANG";
	else if ([@"ATS" isEqualToString:self]) return @"ATS";
	else if ([@"AUD" isEqualToString:self]) return @"AUD";
	else if ([@"BEF" isEqualToString:self]) return @"BEF";
	else if ([@"CAD" isEqualToString:self]) return @"CAD";
	else if ([@"JPY" isEqualToString:self]) return @"JPY";
	else if ([@"CHF" isEqualToString:self]) return @"CHF";
	else if ([@"DEM" isEqualToString:self]) return @"DEM";
	else if ([@"DKK" isEqualToString:self]) return @"DKK";
	else if ([@"ESP" isEqualToString:self]) return @"ESP";
	else if ([@"FRF" isEqualToString:self]) return @"FRF";
	else if ([@"GBP" isEqualToString:self]) return @"£"	 ;
	else if ([@"HKD" isEqualToString:self]) return @"HKD";
	else if ([@"ITL" isEqualToString:self]) return @"ITL";
	else if ([@"LUF" isEqualToString:self]) return @"LUF";
	else if ([@"NOK" isEqualToString:self]) return @"NOK";
	else if ([@"NZD" isEqualToString:self]) return @"NZD";
	else if ([@"SEK" isEqualToString:self]) return @"SEK";
	else if ([@"XEU" isEqualToString:self]) return @"ECU";
	else if ([@"XXX" isEqualToString:self]) return @""	 ;
	return @"";
}

- (NSString*)replaceAdditionalHTMLTags {
	self = [self stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
	self = [self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	self = [self stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
	return self;
}
@end
