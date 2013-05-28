//
//  UINavigationController+Rotation.m
//  itude-mobile-ios-bva-danger
//
//  Created by Frank van Eenbergen on 5/28/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "UINavigationController+Rotation.h"
#import "MBOrientationManager.h"

@implementation UINavigationController (Rotation)



#pragma mark -
#pragma mark iOS 6 and up

- (BOOL)shouldAutorotate
{
    return [[MBOrientationManager sharedInstance] shouldAutorotate];
}


- (NSUInteger)supportedInterfaceOrientations
{
    return [[MBOrientationManager sharedInstance] orientationMask];
}


#pragma mark -
#pragma mark iOS 5 and lower

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [[MBOrientationManager sharedInstance] supportInterfaceOrientation:interfaceOrientation];
}

@end
