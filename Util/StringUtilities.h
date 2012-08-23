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
	
/**
 * Creates a date object from a date string read from XML
 * @note The receiver MUST be a date string in XML format
 * @return Returns an NSDate object formatted from an XML-date string
 */
- (NSDate *)dateFromXML;


/**
 * Formats a price with a minimum of 0 (zero) decimals and a maximum of 3 (three) decimals 
 * @note Used to display neat graph data 10K, 10,1K etc.
 * @return Returns a string formatted as a price with a minimum of 0 (zero) decimals and a maximum of 3 (three) decimals 
 */
- (NSString *)formatPriceWithMinimalDecimals;


/**
 * Creates a string formatted as a number with the original amount of decimals
 * @note This methods assumes that the receiver is a float 
 * @return Returns a string formatted as a number with the original amount of decimals
 */
- (NSString *)formatNumberWithOriginalNumberOfDecimals;


/**
 * Creates a string formatted as a price with excactly 2 (two) decimals
 * @note This method assumes that the receiver is a float string read from XML
 * @return Returns a string formatted as a price with excactly 2 (two) decimals
 */
- (NSString *)formatPriceWithTwoDecimals;


/**
 * Creates a string formatted as a price with excactly 3 (three) decimals
 * @note This method assumes that the receiver is a float string read from XML
 * @return Returns a string formatted as a price with excactly 3 (three) decimals
 */
- (NSString *)formatPriceWithThreeDecimals;


/**
 * Creates a string formatted as a number with excactly 2 (two) decimals
 * @note This method assumes that the receiver is a float string read from XML
 * @return Returns a string formatted as a number with excactly 2 (two) decimals
 */
- (NSString *)formatNumberWithTwoDecimals;


/**
 * Creates a string formatted as a number with excactly 3 (three) decimals
 * @note This method assumes that the receiver is a float string read from XML
 * @return Returns a string formatted as a number with excactly 3 (three) decimals
 */
- (NSString *)formatNumberWithThreeDecimals;


/**
 * Creates a string formatted as a percentage with two decimals
 * @note This method assumes that the receiver is a float string read from XML. 
 * @note The receiver's value should be "as displayed", eg for 30%, the receiver should be 30, not 0.3
 * @return Returns a string formatted as a percentage with two decimals
 */
- (NSString *)formatPercentageWithTwoDecimals;


/**
 * Creates a string formatted as a volume with group seperators (eg, 131.224.000) 
 * @note This method assumes that the receiver is an integer string read from XML
 * @return Returns a string formatted as a volume (number) with group seperators
 */
- (NSString *)formatVolume;


/** 
 * Formats the receivers date string depending on the current date 
 * @note This method assumes that the receiver is a date string
 * @return Returns a string formatted as a time if the receivers date is equal to the current date
 * @return Returns a string formatted as a date if the receivers date is NOT equal to the current date
 */
- (NSString *)formatDateDependingOnCurrentDate;


/**
 * Strips all HTML tags from the reciever
 * @return Returns a string stripped of all HTML tags from the receiver
 */
- (NSString *)stripHTMLTags;


/**
 * This method encodes an XML string. It replaces characters that are not supported in XML by a 
 * characterstring that is supported; e.g. "&" will become @"&amp
 * @return Returns a encoded XML string
 */
- (NSString *)xmlSimpleEscape;

/**
    Checks if this NSString contains any of the following HTML tags:
    * <html>
    * <body>
    * <b>
    * <br>
*/
- (BOOL)hasHTML;


@end
