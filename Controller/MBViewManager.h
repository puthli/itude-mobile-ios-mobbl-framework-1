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
