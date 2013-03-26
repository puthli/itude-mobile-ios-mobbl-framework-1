//
//  MBDefaultTransitionStyle.m
//  itude-mobile-ios-app
//
//  Created by Berry Pleijster on 26-03-13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDefaultTransitionStyle.h"
#import <QuartzCore/QuartzCore.h>

@implementation MBDefaultTransitionStyle

// Return TRUE to use regular iOS page navigation
-(BOOL)animated {
    return YES;
}

- (void)applyTransitionStyleToViewController:(UIViewController *)viewController {
    // empty implementation, default ios transition
    
}

 

@end
