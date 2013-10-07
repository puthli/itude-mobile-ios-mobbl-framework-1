//
//  MBDialogDecorator.h
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 9/27/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBDialogController;
@protocol MBDialogDecorator <NSObject>
@required
- (void)decorateDialog:(MBDialogController *)dialog;
- (void)presentViewController:(UIViewController *)viewController withTransitionStyle:(NSString *)transitionStyle;
- (void)dismissViewController:(UIViewController *)viewController withTransitionStyle:(NSString *)transitionStyle;
@end
