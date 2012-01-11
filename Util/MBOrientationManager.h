//
//  MBOrientationManager.h
//  Core
//
//  Created by Frank van Eenbergen on 2/1/11.
//  Copyright 2011 Itude Mobile BV. All rights reserved.
//



@interface MBOrientationManager : NSObject {

}

/**
 * Checks if the given interfaceOrientation is supported
 * @param interfaceOrientation = the interfaceOrientation that needs to be compared with all supported interfaceOrientations
 * @return Returns TRUE if the provided interfaceOrientation is supported. 
 */
+ (BOOL) supportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
