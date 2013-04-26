//
//  MBDialogController.h
//  Core
//
//  Created by Frank van Eenbergen on 10/18/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPageStackController.h"
#import "MBDialogDefinition.h"
#import "MBSplitViewController.h"
#import "MBPageStackController.h"


@interface MBDialogController : NSObject 

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSMutableArray *pageStacks;

@property (nonatomic, retain) MBSplitViewController *splitViewController;
@property (nonatomic, assign) BOOL keepLeftViewControllerVisibleInPortraitMode;

- (id) initWithDefinition:(MBDialogDefinition*)definition;

- (MBPageStackController *)pageStackControllerWithName:(NSString *)name;


- (void) showActivityIndicator;
- (void) hideActivityIndicator;
- (void) setLeftPageStackController:(MBPageStackController *) pageStackController;
- (void) setRightPageStackController:(MBPageStackController *) pageStackController;
- (void) loadPageStacks;

@end
