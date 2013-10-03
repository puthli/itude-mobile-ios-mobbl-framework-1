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

#import "MBDialogDefinition.h"
#import "MBPage.h"
#import "MBNotificationTypes.h"

#define FIRST_MORE_TAB_INDEX 4

@interface MBDialogController : NSObject <UINavigationControllerDelegate> {

	NSString *_name;
	NSString *_iconName;
	NSString *_title;
	NSString *_dialogMode;
	NSString *_dialogGroupName;
	NSString *_position;
	BOOL _usesNavbar;
	CGRect _bounds;
    UINavigationController *_rootController;
    UINavigationController *_navigationController;
	int _activityIndicatorCount;
	BOOL _temporary;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *dialogMode;
@property (nonatomic, retain) NSString *dialogGroupName;
@property (nonatomic, retain) NSString *position;
@property (nonatomic, retain) UINavigationController *rootController;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) BOOL temporary;

- (id) initWithDefinition:(MBDialogDefinition*)definition temporary:(BOOL) isTemporary;
- (id) initWithDefinition:(MBDialogDefinition*)definition page:(MBPage*) page bounds:(CGRect) bounds;
- (void) showPage:(MBPage*) page displayMode:(NSString*) displayMode;
-(void) popPageAnimated:(BOOL) animated;
- (UIView*) view;
- (CGRect) screenBoundsForDisplayMode:(NSString*) displayMode;
- (void) showActivityIndicator;
- (void) hideActivityIndicator;

@end
