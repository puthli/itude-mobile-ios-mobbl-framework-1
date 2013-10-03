/*
 * (C) Copyright Google Inc.
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

#import "MBDevice.h"
#import "MBMacros.h"

#import "MBDocument.h"
#import "MBDataManagerService.h"
#import "MBMacros.h"

// UIUserInterfaceIdiom is only available for IOS 3.2 and higher
#define UIUSERINTERFACEIDOMIMPLVERSION	3.2f

static MBDevice *_instance = nil;

@implementation MBDevice

@synthesize currentSystemVersion = _currentSystemVersion;
@synthesize currentSystemVersionAsString = _currentSystemVersionAsString;
@synthesize deviceName = _deviceName;
@synthesize deviceIsPad = _deviceIsPad;
@synthesize deviceIsPhone = _deviceIsPhone;
@synthesize deviceIsPod = _deviceIsPod;

+ (void) createInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}	
}


- (id) init
{
    
    self = [super init];
	if (self != nil) {
        
        self.currentSystemVersionAsString = [[UIDevice currentDevice] systemVersion];
		self.currentSystemVersion = [self.currentSystemVersionAsString floatValue];
		
		// Determine the deviceType
		self.deviceName = [[UIDevice currentDevice] model];
		if ([self currentSystemVersion] >= UIUSERINTERFACEIDOMIMPLVERSION)	{
			self.deviceIsPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
			self.deviceIsPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
		}
		else {

			DLog(@"MBDevice:isDeviceTypeName; WARNING! This device is NOT running on IOS 3.2 or higher! Trying to recognize the deviceType using the deviceName!");

			NSRange padRange = [self.deviceName rangeOfString:@"iPad"];
			self.deviceIsPad = !(padRange.location == NSNotFound);
			
			NSRange phoneRange = [self.deviceName rangeOfString:@"iPhone"];
			self.deviceIsPhone = !(phoneRange.location == NSNotFound);
		}
		
		// To determine if a device is an iPod, we need to search for the deviceName
		NSRange podRange = [self.deviceName rangeOfString:@"iPod"];
		self.deviceIsPod = !(podRange.location == NSNotFound);
				
	}
	return self;
}

+(CGFloat) iOSVersion {
	return [_instance currentSystemVersion];
}

+(NSString *)iOSVersionAsString {
	return [_instance currentSystemVersionAsString];
}

+(NSString *)deviceName {
	return [_instance deviceName];
}

// NOTE: To Make an iPhone only release, this method must always return NO
+(BOOL) isPad {
	return [_instance deviceIsPad];
}

+(BOOL) isPhone {
	return [_instance deviceIsPhone];
}

+(BOOL) isPod {
	return [_instance deviceIsPod];
}

+(NSString*) identifier {
    MBDocument *deviceDocument = [[MBDataManagerService sharedInstance] loadDocument:@"DeviceState"];
    NSString *identifier = [deviceDocument valueForPath:@"Device[0]/@identifier"];
    if (!identifier) 
    {
        identifier = [self uuid];
        [deviceDocument setValue:identifier forPath:@"/Device[0]/@identifier"];
        [[MBDataManagerService sharedInstance] storeDocument:deviceDocument];
        DLog(@"No identifier found: %@", identifier);
    }
    return identifier;
}

+(NSString *)uuid
{
    // Creates a Universally Unique Identifier (UUID) object.
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Returns the string representation of a specified CFUUID object.
    NSString *uuid = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    CFRelease(uuidObject);
    
    return [uuid autorelease];
}

@end
