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
#import "MBTransitionStyles.h"
#import "MBTransitionStyle.h"

@interface MBTransitionStyleFactory : NSObject

/// @name Registering MBTransitionStyle instances
- (void)registerTransition:(id<MBTransitionStyle>)transition forTransitionStyle:(NSString *)transitionStyle;

/// @name Getting a MBTransitionStyle instance
@property (nonatomic, retain) id<MBTransitionStyle> defaultTransition;
- (id<MBTransitionStyle>)transitionForStyle:(NSString*)transitionStyle;

/// @name Applying TransitionStyles
- (void) applyTransitionStyle:(NSString *)transitionStyle withMovement:(MBTransitionMovement)transitionMovement forViewController:(UIViewController *)viewController;

@end
