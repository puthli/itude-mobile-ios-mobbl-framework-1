//
//  UIViewController+Rotation.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 8/19/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "UIViewController+Rotation.h"
#import "MBOrientationManager.h"

@implementation UIViewController (Rotation)

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
