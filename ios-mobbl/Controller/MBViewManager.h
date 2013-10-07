//
//  MBViewManager.h
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBTypes.h"
#import "MBDialogManager.h"

@class MBPage;
@class MBAlert;

@interface MBViewManager : NSObject<UITabBarControllerDelegate, UINavigationControllerDelegate, MBDialogManagerDelegate>
@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) MBDialogManager *dialogManager;
@property (nonatomic, retain) UIAlertView *currentAlert;

- (id) init;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitionStyle:(NSString *) style;
- (void) showAlert:(MBAlert *) alert;

- (void) showActivityIndicator;
- (void) showActivityIndicatorWithMessage:(NSString*) message;
- (void) hideActivityIndicator;
- (void) makeKeyAndVisible;

- (CGRect) bounds;

- (void) resetView;
- (void) resetViewPreservingCurrentPageStack;
- (void) endModalPageStack;
- (MBViewState) currentViewState;

/**
 * Used to present and dismiss a (modal) viewController
 */
- (void) presentViewController:(UIViewController *)controller fromViewController:(UIViewController *)fromViewController animated:(BOOL)animated;
- (void) dismisViewController:(UIViewController *)controller animated:(BOOL)animated;

/**
 * Returns the top most visibile viewController. In most cases this will be the rootViewController of the UIWindow or the modalViewController of the UIWindow.
 */
- (UIViewController *)topMostVisibleViewController;

@end
