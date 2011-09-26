//
//  StringUtilitiesHelper.h
//  Core
//
//  Created by Frank van Eenbergen on 2/23/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//


// NOTE: This class is used as a helper to improve performance! It keeps track of all the different numberformatters so they can easly be reused without having to create an instance for each one
@interface StringUtilitiesHelper : NSObject {
	NSDateFormatter *_dateFormatterToFormatDateFromXml;
	NSDateFormatter *_dateFormatterToFormatDateDependingOnCurrentDate;
	NSNumberFormatter *_volumeNumberFormatter;
	NSNumberFormatter *_priceWithMinimalDecimalsNumberFormatter;
	NSNumberFormatter *_priceWithTwoDecimalsNumberFormatter;
	NSNumberFormatter *_priceWithThreeDecimalsNumberFormatter;
	NSNumberFormatter *_numberWithOriginalNumberOfDecimalsNumberFormatter;
	NSNumberFormatter *_numberWithTwoDecimalsNumberFormatter;
	NSNumberFormatter *_numberWithThreeDecimalsNumberFormatter;
}

@property (nonatomic, retain) NSDateFormatter *dateFormatterToFormatDateFromXml;
@property (nonatomic, retain) NSDateFormatter *dateFormatterToFormatDateDependingOnCurrentDate;
@property (nonatomic, retain) NSNumberFormatter	*volumeNumberFormatter;
@property (nonatomic, retain) NSNumberFormatter	*priceWithMinimalDecimalsNumberFormatter;
@property (nonatomic, retain) NSNumberFormatter	*priceWithTwoDecimalsNumberFormatter;
@property (nonatomic, retain) NSNumberFormatter	*priceWithThreeDecimalsNumberFormatter;
@property (nonatomic, retain) NSNumberFormatter	*numberWithOriginalNumberOfDecimalsNumberFormatter;
@property (nonatomic, retain) NSNumberFormatter	*numberWithTwoDecimalsNumberFormatter;
@property (nonatomic, retain) NSNumberFormatter	*numberWithThreeDecimalsNumberFormatter;


+ (void) createInstance;
+ (NSDateFormatter *)dateFormatterToFormatDateFromXml;
+ (NSDateFormatter *)dateFormatterToFormatDateDependingOnCurrentDate;
+ (NSNumberFormatter *)numberFormatterToFormatVolume;
+ (NSNumberFormatter *)numberFormatterToFormatPriceWithMinimalDecimals;
+ (NSNumberFormatter *)numberFormatterToFormatPriceWithTwoDecimals;
+ (NSNumberFormatter *)numberFormatterToFormatPriceWithThreeDecimals;
+ (NSNumberFormatter *)numberFormatterToFormatNumberWithOriginalNumberOfDecimals;
+ (NSNumberFormatter *)numberFormatterToFormatNumberWithTwoDecimals;
+ (NSNumberFormatter *)numberFormatterToFormatNumberWithThreeDecimals;

@end
