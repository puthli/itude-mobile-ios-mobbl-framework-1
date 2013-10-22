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

#import "MBOrientationManager.h"

static MBOrientationManager *_instance = nil;

@implementation MBOrientationManager

@synthesize orientationMask = _orientationMask;
@synthesize shouldAutorotate = _shouldAutorotate;

+ (MBOrientationManager *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        // ShouldAutoRotate is TRUE by default
        _shouldAutorotate = YES;
    }
    return self;
}


// Returns TRUE if the interfaceOrientation is allowed
- (BOOL) supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    // Bitshift the interfaceOrientation to compare if it is in the allowed mask
    return self.orientationMask & (1 << interfaceOrientation);
}

- (UIInterfaceOrientationMask)orientationMask {
    
    // Set a defaultOrientationMask if none is set
    if (_orientationMask == 0) {
        // Default is all orientations.
        // If you want to override this behaviour, set the orientationmask in your project's appDelegate class
        _orientationMask = UIInterfaceOrientationMaskAll;
    }
    
    return _orientationMask;

}

@end
