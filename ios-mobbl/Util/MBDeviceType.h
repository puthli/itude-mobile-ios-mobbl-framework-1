//
//  MBDeviceType.h
//  Core
//
//  Created by Frank van Eenbergen on 10/13/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//



@interface MBDeviceType : NSObject {
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

+(void) createInstance;

+(CGFloat)iOSVersion;
+(NSString *)iOSVersionAsString;
+(NSString *)deviceName;
+(BOOL) isPad;
+(BOOL) isPhone;
+(BOOL) isPod;

@end
