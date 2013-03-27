//
//  MBBasicTransitionStyle.m
//  itude-mobile-ios-app
//
//  Created by Berry Pleijster on 27-03-13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBBasicTransitionStyle.h"

@implementation MBBasicTransitionStyle

@synthesize isModal = _isModal;

// return YES for modals and NO for normal VCs
-(BOOL)animated {
    if (self.isModal) {
        return YES;
    }
    return NO;
}

- (void)applyTransitionStyleToViewController:(UIViewController *)viewController modal:(BOOL)modal {
    if (modal) {
        self.isModal = YES;
    }
}

@end
