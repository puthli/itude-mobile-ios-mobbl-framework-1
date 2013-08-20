//
//  MBSplitDialogContentBuilder.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 5/6/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBSplitDialogContentBuilder.h"
#import "MBSplitViewController.h"
#import "MBDialogController.h"

@implementation MBSplitDialogContentBuilder

-(UIViewController *)buildDialogContentViewControllerForDialog:(MBDialogController *)dialogController {
    MBSplitViewController *containerViewController = [[[MBSplitViewController alloc] initWithLeftViewControllerVisibleInPortraitMode:YES] autorelease];
    if (dialogController.pageStackControllers.count > 1) {
        MBPageStackController *leftPageStackController = [dialogController.pageStackControllers objectAtIndex:0];
        [containerViewController setMasterViewController:leftPageStackController.navigationController];
        MBPageStackController *rightPageStackController = [dialogController.pageStackControllers objectAtIndex:1];
        [containerViewController setDetailViewController:rightPageStackController.navigationController];
    }
    return containerViewController;
}

@end
