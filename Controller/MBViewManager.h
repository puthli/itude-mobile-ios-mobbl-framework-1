//
//  MBViewManager.h
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBTypes.h"
@class MBPage;
@class MBAlert;

@interface MBViewManager : NSObject<UITabBarControllerDelegate> {
	UIWindow *_window;
	UITabBarController *_tabController;
	NSMutableDictionary *_dialogControllers;
	NSMutableDictionary *_dialogGroupControllers;
	NSMutableDictionary *_activityIndicatorCounts;
	NSMutableArray *_dialogControllersOrdered;
	NSMutableArray *_dialogGroupControllersOrdered;
	NSMutableArray *_sortedNewDialogNames;
	NSString *_activeDialogName;
	NSString *_activeDialogGroupName;
	UIAlertView *_currentAlert;
	UINavigationController *_modalController;
	int _activityIndicatorCount;
	BOOL _singlePageMode;
}

@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) NSString *activeDialogName;
@property (nonatomic, retain) NSString *activeDialogGroupName;
@property (nonatomic, retain) UIAlertView *currentAlert;
@property (nonatomic, assign) BOOL singlePageMode;

- (id) init;
- (CGRect) screenBoundsForDialog:(NSString*) dialogName displayMode:(NSString*) mode;
- (void) showPage:(MBPage*) page displayMode:(NSString*) mode;
- (void) showPage:(MBPage*) page displayMode:(NSString*) mode transitioningStyle:(NSString *) style;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode selectDialog:(BOOL) shouldSelectDialog;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitioningStyle:(NSString *) style selectDialog:(BOOL) shouldSelectDialog;
- (void) showAlert:(MBAlert *) alert;
- (void) activateDialogWithName:(NSString*) dialogName;
- (void) endDialog:(NSString*) dialogName keepPosition:(BOOL) keepPosition;
- (void) popPage:(NSString*) dialogName;
- (void) showActivityIndicatorForDialog:(NSString*) dialogName;
- (void) hideActivityIndicatorForDialog:(NSString*) dialogName;
- (void) makeKeyAndVisible;
- (void) notifyDialogUsage:(NSString*) dialogName;
- (CGRect) bounds;
- (NSString*) activeDialogName;
- (void) resetView;
- (void) resetViewPreservingCurrentDialog;
- (void) endModalDialog;
- (MBViewState) currentViewState;
@end
