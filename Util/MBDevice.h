//
//  MBDevice.h
//  Core
//
//  Created by Frank van Eenbergen on 10/13/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


@interface MBDevice : NSObject {
	CGFloat _currentSystemVersion;
	NSString *_currentSystemVersionAsString;
	NSString *_deviceName;
	BOOL _deviceIsPad;
	BOOL _deviceIsPhone;
	BOOL _deviceIsPod;
}

@property (nonatomic, assign) CGFloat currentSystemVersion;
@property (nonatomic, retain) NSString *currentSystemVersionAsString;
@property (nonatomic, retain) NSString *deviceName;
@property (nonatomic, assign) BOOL deviceIsPad;
@property (nonatomic, assign) BOOL deviceIsPhone;
@property (nonatomic, assign) BOOL deviceIsPod;

/**
 * Creates an instance for this helper class
 *
 * @note IMPORTANT NOTE: This instance MUST be created when the application starts up for the verry first time 
 * because methods in this class are called at the verry beginning of the application and an instance must exist!
 * Currently, that is in the init of the MBApplicationController.
 */
+(void) createInstance;

/**
 * The methods below return properties of MBDevice in a verry efficient way. They can be called frequently, if needed.
 * @note IMPORTANT!!! An instance of MBDevice MUST be created before any of the methods below can be called
 */
+(CGFloat)iOSVersion;
+(NSString *)iOSVersionAsString;
+(NSString *)deviceName;
+(BOOL) isPad;
+(BOOL) isPhone;
+(BOOL) isPod;

@end
