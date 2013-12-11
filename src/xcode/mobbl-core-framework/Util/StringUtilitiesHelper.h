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


/** 
 * This class is used as a helper to improve performance! 
 * It keeps track of all the different numberformatters so they can easly be reused.
 */
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

/**
 * Creates an instance for this helper class
 *
 * @note IMPORTANT NOTE: This instance is created once in the startApplication method in MBApplicationController.
 * This is directly after the application launched and well before the helper is needed for the first time.  
 */
+ (void) createInstance;


/** 
 * All the methods below return the appropriate formatter that is used in StringUtilities
 */
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
