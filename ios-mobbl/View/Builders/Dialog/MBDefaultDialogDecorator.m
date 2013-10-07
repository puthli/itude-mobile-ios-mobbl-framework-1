//
//  MBDefaultDialogDecorator.m
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 9/27/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBDefaultDialogDecorator.h"

@implementation MBDefaultDialogDecorator

- (void)decorateViewController:(UIViewController *)viewController displayMode:(NSString *)displayMode {
    // Default: Do nothing. 
}

- (void)presentViewController:(UIViewController *)viewController withTransitionStyle:(NSString *)transitionStyle {
    // Default: Do nothing. The Viewmanager is responsible for default DialogDecorators
}

@end
