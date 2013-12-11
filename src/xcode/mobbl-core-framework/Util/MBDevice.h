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

/** returns information about the physical device */
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
+(NSString*) identifier;
+(BOOL) isPad;
+(BOOL) isPhone;
+(BOOL) isPod;

+(NSString *)uuid;

@end
