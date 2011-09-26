//
//  MBDialogGroupController.h
//  Core
//
//  Created by Frank van Eenbergen on 10/18/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

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
