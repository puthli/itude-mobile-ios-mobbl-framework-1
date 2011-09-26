//
//  StringUtilies.h
//  Core
//
//  Created by Wido on 25-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

@interface NSString(StringUtilities) 

- (NSNumber*) asNumber;
- (NSString*) stripCharacters:(NSString*)characters;
- (NSMutableArray*) splitPath;
- (NSString*) normalizedPath;
- (NSComparisonResult)compareInt:(NSString *)other;
- (NSComparisonResult)compareDouble:(NSString *)other;
- (NSComparisonResult)compareFloat:(NSString *)other;
- (NSComparisonResult)compareBoolean:(NSString *)other;
	
// create a date assuming the receiver is a date string read from XML
- (NSDate *)dateFromXML;

// returns a string formatted as a price with zero or max 3 decimals
// used to display neat graph data 10K, 10,1K etc.
- (NSString *)formatPriceWithMinimalDecimals;

// returns a string formatted as a number with the original amount of decimals assuming the receiver is a float 
- (NSString *)formatNumberWithOriginalNumberOfDecimals;

// returns a string formatted as a price with two decimals assuming the receiver is a float string read from XML
- (NSString *)formatPriceWithTwoDecimals;

// returns a string formatted as a price with three decimals assuming the receiver is a float string read from XML
- (NSString *)formatPriceWithThreeDecimals;

// returns a string formatted as a number with two decimals assuming the receiver is a float string read from XML
- (NSString *)formatNumberWithTwoDecimals;

// returns a string formatted as a number with three decimals assuming the receiver is a float string read from XML
- (NSString *)formatNumberWithThreeDecimals;

// returns a string formatted as a percentage with two decimals assuming the receiver is a float string read from XML
// the receiver's value should be "as displayed", eg for 30%, the receiver should be 30, not 0.3
- (NSString *)formatPercentageWithTwoDecimals;

// returns a string formatted as a volume with group separators (eg, 131.224.000) assuming the receiver is an int string read from XML
- (NSString *)formatVolume;

// Formats the date depending on the current date assuming the receiver is a date string 
// If the date is equal to the current date, the time is given back as a string
// If the date is NOT equal to the current date, then a a date is presented back as a string
- (NSString *)formatDateDependingOnCurrentDate;

// returns a string stripped of all HTML tags from the receiver
- (NSString *)stripHTMLTags;

// XML Encoding
- (NSString *)xmlSimpleEscape;

@end
