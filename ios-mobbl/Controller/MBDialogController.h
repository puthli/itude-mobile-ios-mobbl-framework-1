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
@property (nonatomic, retain) NSString *showAs;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSMutableArray *pageStackControllers;
@property (nonatomic, retain) UIViewController *rootViewController;


- (id) initWithDefinition:(MBDialogDefinition*)definition;

- (MBPageStackController *)pageStackControllerWithName:(NSString *)name;


- (void) showActivityIndicator;
- (void) hideActivityIndicator;

- (BOOL) showAsTab;

@end
