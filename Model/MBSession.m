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

#import "MBSession.h"
#import "MBDocument.h"
#import "MBDataManagerService.h"

static MBSession *_instance = nil;

@implementation MBSession

+(MBSession *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

+(void) setSharedInstance:(MBSession *) session {
	@synchronized(self) {
		if(_instance != nil && _instance != session) {
			[_instance release];
		}
		_instance = session;
		[_instance retain];
	}
}

//
// Override the following methods in an instance specific for your app; and register it app startup with setSharedInstance
//
-(MBDocument*) document {
    return nil;
}

-(void) logOff {
}

- (BOOL)loggedOn {
	return NO;
}

@end
