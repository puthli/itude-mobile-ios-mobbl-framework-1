/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
