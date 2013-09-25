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
- (void) showPage:(MBPage*) page displayMode:(NSString*) mode;
- (void) showPage:(MBPage*) page displayMode:(NSString*) mode transitionStyle:(NSString *) style;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode selectPageStack:(BOOL) shouldSelectPageStack;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitionStyle:(NSString *) style selectPageStack:(BOOL) shouldSelectPageStack;
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
 * Returns the top most visibile viewController. In most cases this will be the rootViewController of the UIWindow or the modalViewController of the UIWindow.
 */
- (UIViewController *)topMostVisibleViewController;

@end
