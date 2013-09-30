//
//  MBFlipTransitionStyle.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 4/9/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBFlipTransitionStyle.h"
#import <QuartzCore/QuartzCore.h>

@implementation MBFlipTransitionStyle

- (BOOL)animated {
    return NO;
}

- (void)applyTransitionStyleToViewController:(UIViewController *)viewController forMovement:(MBTransitionMovement)transitionMovement {

    // Modal Flips
    //viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Flip for regular pushes on the navigationStack
    [UIView beginAnimations:@"MBFlipAnimation" context:nil];
	[UIView setAnimationDuration:1.0];
    switch (transitionMovement) {
        case MBTransitionMovementPush: {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:viewController.view cache:YES];
            break;
        }
        case MBTransitionMovementPop: {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:viewController.view cache:YES];
            break;
        }
            
        default:
            break;
    }
    
    
	[UIView commitAnimations];

}

@end
