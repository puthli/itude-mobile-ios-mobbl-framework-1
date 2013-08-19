//
//  MBSingleDialogBuilder.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 5/6/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBSingleDialogContentBuilder.h"
#import "MBDialogController.h"
#import "MBPageStackController.h"

@implementation MBSingleDialogContentBuilder

-(UIViewController *)buildDialogContentViewControllerForDialog:(MBDialogController *)dialogController {
    if (dialogController.pageStackControllers.count > 0) {
        MBPageStackController *pageStackController = [dialogController.pageStackControllers objectAtIndex:0];
        return pageStackController.navigationController;
    }
    
    return nil;
}

@end
