//
//  MBOrientationManager.h
//  Core
//
//  Created by Frank van Eenbergen on 2/1/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//



@interface MBOrientationManager : NSObject {

}
@property (nonatomic, assign) UIInterfaceOrientationMask orientationMask;
@property (nonatomic, assign) BOOL shouldAutorotate;

/// @name Getting a service instance
/** The shared instance */
+ (MBOrientationManager *) sharedInstance;

/**
 * Checks if the given interfaceOrientation is supported
 * @param interfaceOrientation = the interfaceOrientation that needs to be compared with all supported interfaceOrientations
 * @return Returns TRUE if the provided interfaceOrientation is supported. 
 */
- (BOOL) supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

//// iOS 5.1 and lower
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;


// iOS 6.0 and higher
- (BOOL) shouldAutorotate;
//- (NSUInteger)supportedInterfaceOrientations;

@end
