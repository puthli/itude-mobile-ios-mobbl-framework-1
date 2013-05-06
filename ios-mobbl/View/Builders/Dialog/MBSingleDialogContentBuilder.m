//
//  MBSingleDialogBuilder.m
//  itude-mobile-ios-app
//
//  Created by Frank van Eenbergen on 5/6/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBSingleDialogContentBuilder.h"

@implementation MBSingleDialogContentBuilder

-(UIView *)buildDialogContent:(MBDialogController *)dialogController {
    if (!dialogController.rootViewController) {
        dialogController.rootViewController = [[[UIViewController alloc] init] autorelease];
        
        if (dialogController.pageStackControllers.count > 0) {
            MBPageStackController *pageStackController = [dialogController.pageStackController objectAtIndex:0];
            [self.rootViewController.view addSubview:pageStackController.navigationController.view]
            
        }
    }
    
    return self.rootViewController.view;
}

@end
