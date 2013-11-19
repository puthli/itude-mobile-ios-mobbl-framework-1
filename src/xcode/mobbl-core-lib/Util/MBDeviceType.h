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
