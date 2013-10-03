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

#import "MBDialogController.h"
#import "MBDialogGroupDefinition.h"
#import "MBSplitViewController.h"


@interface MBDialogGroupController : NSObject {
	
	NSString *_name;
	NSString *_iconName;
	NSString *_title;
	MBDialogController *_leftDialogController;
	MBDialogController *_rightDialogController;
	MBSplitViewController *_splitViewController;
	BOOL _keepLeftViewControllerVisibleInPortraitMode;
	NSInteger _activityIndicatorCount;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) MBSplitViewController *splitViewController;
@property (nonatomic, assign) BOOL keepLeftViewControllerVisibleInPortraitMode;

- (id) initWithDefinition:(MBDialogGroupDefinition*)definition;
- (void) showActivityIndicator;
- (void) hideActivityIndicator;
- (void) setLeftDialogController:(MBDialogController *) dialogController;
- (void) setRightDialogController:(MBDialogController *) dialogController;
- (void) loadDialogs;

@end
