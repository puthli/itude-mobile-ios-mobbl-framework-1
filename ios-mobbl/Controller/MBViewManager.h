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

@interface MBViewManager : NSObject<UITabBarControllerDelegate, UINavigationControllerDelegate> {
	UIWindow *_window;
	UITabBarController *_tabController;
	NSMutableDictionary *_pageStackControllers;
	NSMutableDictionary *_dialogGroupControllers;
	NSMutableDictionary *_activityIndicatorCounts;
	NSMutableArray *_pageStackControllersOrdered;
	NSMutableArray *_dialogGroupControllersOrdered;
	NSMutableArray *_sortedNewPageStackNames;
	NSString *_activePageStackName;
	NSString *_activeDialogGroupName;
	UIAlertView *_currentAlert;
	UINavigationController *_modalController;
	int _activityIndicatorCount;
	BOOL _singlePageMode;
}

@property (nonatomic, readonly) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) NSString *activePageStackName;
@property (nonatomic, retain) NSString *activeDialogGroupName;
@property (nonatomic, retain) UIAlertView *currentAlert;
@property (nonatomic, assign) BOOL singlePageMode;

- (id) init;
- (void) showPage:(MBPage*) page displayMode:(NSString*) mode;
- (void) showPage:(MBPage*) page displayMode:(NSString*) mode transitionStyle:(NSString *) style;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode selectPageStack:(BOOL) shouldSelectPageStack;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode transitionStyle:(NSString *) style selectPageStack:(BOOL) shouldSelectPageStack;
- (void) showAlert:(MBAlert *) alert;
- (void) activatePageStackWithName:(NSString*) pageStackName; // Called using selectors. 
- (void) endPageStackWithName:(NSString*) pageStackName keepPosition:(BOOL) keepPosition;
- (void) popPage:(NSString*) pageStackName;
- (void) showActivityIndicator;
- (void) hideActivityIndicator;
- (void) makeKeyAndVisible;
- (void) notifyPageStackUsage:(NSString*) pageStackName;
- (CGRect) bounds;
- (NSString*) activePageStackName;
- (void) resetView;
- (void) resetViewPreservingCurrentPageStack;
- (void) endModalPageStack;
- (MBViewState) currentViewState;
@end
