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

#import "MBFadeTransitionStyle.h"
#import <QuartzCore/QuartzCore.h>

@implementation MBFadeTransitionStyle

-(BOOL)animated {
    return NO;
}

- (void)applyTransitionStyleToViewController:(UIViewController *)viewController forMovement:(MBTransitionMovement)transitionMovement {

    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [viewController.view.layer addAnimation:transition forKey:kCATransition];
}

@end
