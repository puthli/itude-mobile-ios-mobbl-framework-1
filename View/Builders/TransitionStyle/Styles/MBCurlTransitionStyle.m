//
//  MBCurlTransitionStyle.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 4/9/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBCurlTransitionStyle.h"

@implementation MBCurlTransitionStyle

-(BOOL)animated {
    return NO;
}

- (void)applyTransitionStyleToViewController:(UIViewController *)viewController forMovement:(MBTransitionMovement)transitionMovement {
    
    // Modal Partial Curl
    viewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    // Flip for regular pushes on the navigationStack
    [UIView beginAnimations:@"MBFlipAnimation" context:nil];
	[UIView setAnimationDuration:1.0];
    switch (transitionMovement) {
        case MBTransitionMovementPush: {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:viewController.view cache:YES];
            break;
        }
        case MBTransitionMovementPop: {
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:viewController.view cache:YES];
            break;
        }
            
        default:
            break;
    }
    
    
	[UIView commitAnimations];
    
}

@end
