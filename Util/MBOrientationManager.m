//
//  MBOrientationManager.m
//  Core
//
//  Created by Frank van Eenbergen on 2/1/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//

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
