/*
 * (C) Copyright ItudeMobile.
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

#import "MBFlipTransitionStyle.h"
#import <QuartzCore/QuartzCore.h>

@implementation MBFlipTransitionStyle

- (BOOL)animated {
    return NO;
}

- (void)applyTransitionStyleToViewController:(UIViewController *)viewController forMovement:(MBTransitionMovement)transitionMovement {

    // Modal Flips
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
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
