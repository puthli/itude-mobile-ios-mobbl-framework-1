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

#import "MBTypes.h"
@class MBPage;
@class MBAlert;

@interface MBViewManager : NSObject<UITabBarControllerDelegate, UINavigationControllerDelegate> 
@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) NSString *activePageStackName;
@property (nonatomic, retain) NSString *activeDialogName;
@property (nonatomic, retain) UIAlertView *currentAlert;

- (id) init;
- (void) showPage:(MBPage*) page displayMode:(NSString*) mode;
- (void) showPage:(MBPage*) page displayMode:(NSString*) mode transitionStyle:(NSString *) style;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode selectPageStack:(BOOL) shouldSelectPageStack;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitionStyle:(NSString *) style selectPageStack:(BOOL) shouldSelectPageStack;
- (void) showAlert:(MBAlert *) alert;
- (void) activatePageStackWithName:(NSString*) pageStackName; // Called using selectors. 
- (void) endPageStackWithName:(NSString*) pageStackName keepPosition:(BOOL) keepPosition;
- (void) popPageOnPageStackWithName:(NSString*) pageStackName;
- (void) showActivityIndicator;
- (void) showActivityIndicatorWithMessage:(NSString*) message;
- (void) hideActivityIndicator;
- (void) makeKeyAndVisible;
- (void) notifyPageStackUsage:(NSString*) pageStackName;
- (CGRect) bounds;
- (NSString*) activePageStackName;
- (void) resetView;
- (void) resetViewPreservingCurrentPageStack;
- (void) endModalPageStack;
- (MBViewState) currentViewState;
- (void) updateDisplay;
/**
 * Returns the top most visibile viewController. In most cases this will be the rootViewController of the UIWindow or the modalViewController of the UIWindow.
 */
- (UIViewController *)topMostVisibleViewController;

@end
