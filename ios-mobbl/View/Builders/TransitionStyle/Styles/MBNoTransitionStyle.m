//
//  MBNoTransitionStyle.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 4/16/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBNoTransitionStyle.h"

@implementation MBNoTransitionStyle

// Return FALSE for no animation in the transition
- (BOOL)animated {
    return NO;
}

- (void)applyTransitionStyleToViewController:(UIViewController *)viewController forMovement:(MBTransitionMovement)transitionMovement {
    // default implementation, normal transition
}


@end
