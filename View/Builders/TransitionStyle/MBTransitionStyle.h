//
//  MBTransitionStyle.h
//  itude-mobile-ios-app
//
//  Created by Berry Pleijster on 26-03-13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>


enum MBTransitionMovementEnum {
	MBTransitionMovementPush=0, MBTransitionMovementPop=1
};
typedef NSUInteger MBTransitionMovement;

/**
 * Protocol used by TransitionStyle instances. Implement this interface for custom TransitionStyles.
 */
@protocol MBTransitionStyle <NSObject>

/** Return TRUE to use regular iOS page navigation */
- (BOOL) animated;

/** Implement your modal and regular navigation in this method. Use transitionMovement to determine the movement */
- (void) applyTransitionStyleToViewController:(UIViewController *)viewController forMovement:(MBTransitionMovement)transitionMovement;

@end
