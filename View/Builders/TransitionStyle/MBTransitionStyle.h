//
//  MBTransitionStyle.h
//  itude-mobile-ios-app
//
//  Created by Berry Pleijster on 26-03-13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Protocol used by TransitionStyle instances. Implement this interface for custom TransitionStyles.
 */
@protocol MBTransitionStyle <NSObject>

/** Return TRUE to use regular iOS page navigation */
- (BOOL) animated;

/** Return TRUE to use regular iOS page navigation */
- (void) applyTransitionStyleToViewController:(UIViewController *)viewController modal:(BOOL)modal;

@end
