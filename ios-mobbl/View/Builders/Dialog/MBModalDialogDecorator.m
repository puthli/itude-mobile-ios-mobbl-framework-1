//
//  MBModalDialogContentBuilder.m
//  itude-mobile-ios-chep-uld
//
//  Created by Frank van Eenbergen on 9/27/13.
//  Copyright (c) 2013 Itude Mobile. All rights reserved.
//

#import "MBModalDialogDecorator.h"
#import "MBDialogController.h"
#import "MBPageStackController.h"
#import "MBLocalizationService.h"

@implementation MBModalDialogDecorator

- (void)decorateDialog:(MBDialogController *)dialog {
    
    // TODO: displayMode is set to the decorator for now (which is @"MODAL"). Should be different (different decorators for different modal types).
    NSString *displayMode = dialog.decorator;
    UIViewController *viewController = dialog.rootViewController;

    if([@"MODAL" isEqualToString:displayMode] ||
        [@"MODALWITHCLOSEBUTTON" isEqualToString:displayMode] ||
        [@"MODALFORMSHEET" isEqualToString:displayMode] ||
        [@"MODALFORMSHEETWITHCLOSEBUTTON" isEqualToString:displayMode] ||
        [@"MODALPAGESHEET" isEqualToString:displayMode] ||
        [@"MODALPAGESHEETWITHCLOSEBUTTON" isEqualToString:displayMode] ||
        [@"MODALFULLSCREEN" isEqualToString:displayMode] ||
        [@"MODALFULLSCREENWITHCLOSEBUTTON" isEqualToString:displayMode] ||
        [@"MODALCURRENTCONTEXT" isEqualToString:displayMode] ||
        [@"MODALCURRENTCONTEXTWITHCLOSEBUTTON" isEqualToString:displayMode]) {
           
           BOOL addCloseButton = NO;
           UIModalPresentationStyle modalPresentationStyle = UIModalPresentationFormSheet;
           if ([@"MODALFORMSHEET" isEqualToString:displayMode])			modalPresentationStyle = UIModalPresentationFormSheet;
           else if ([@"MODALPAGESHEET" isEqualToString:displayMode])		modalPresentationStyle = UIModalPresentationPageSheet;
           else if ([@"MODALFULLSCREEN" isEqualToString:displayMode])		modalPresentationStyle = UIModalPresentationFullScreen;
           else if ([@"MODALCURRENTCONTEXT" isEqualToString:displayMode])	modalPresentationStyle = UIModalPresentationCurrentContext;
           else if ([@"MODALWITHCLOSEBUTTON" isEqualToString:displayMode]) addCloseButton = YES;
           else if ([@"MODALFORMSHEETWITHCLOSEBUTTON" isEqualToString:displayMode]) {
               addCloseButton = YES;
               modalPresentationStyle = UIModalPresentationFormSheet;
           }
           else if ([@"MODALPAGESHEETWITHCLOSEBUTTON" isEqualToString:displayMode]) {
               addCloseButton = YES;
               modalPresentationStyle = UIModalPresentationPageSheet;
           }
           else if ([@"MODALFULLSCREENWITHCLOSEBUTTON" isEqualToString:displayMode]) {
               addCloseButton = YES;
               modalPresentationStyle = UIModalPresentationFullScreen;
           }
           else if ([@"MODALCURRENTCONTEXTWITHCLOSEBUTTON" isEqualToString:displayMode]) {
               addCloseButton = YES;
               modalPresentationStyle = UIModalPresentationCurrentContext;
           }
           

           viewController.modalPresentationStyle = modalPresentationStyle;
        
           
           if (addCloseButton) {
               NSString *closeButtonTitle = MBLocalizedString(@"closeButtonTitle");
               // TODO: We need to use dismissDialog: transitionStyle: instead of endModalPageStack
               id delegate = [[MBApplicationController currentInstance] viewManager];
               UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] initWithTitle:closeButtonTitle style:UIBarButtonItemStyleBordered target:delegate action:@selector(endModalPageStack)] autorelease];
               [viewController.navigationItem setRightBarButtonItem:closeButton animated:YES];
           }
        
       }

}

- (void)presentViewController:(UIViewController *)viewController withTransitionStyle:(NSString *)transitionStyle {
    id<MBTransitionStyle> transition = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
    [transition applyTransitionStyleToViewController:viewController forMovement:MBTransitionMovementPush];
    BOOL animated = [transition animated];

    UIViewController *topMostVisibleViewController = [[[MBApplicationController currentInstance] viewManager] topMostVisibleViewController];
    [[[MBApplicationController currentInstance] viewManager] presentViewController:viewController fromViewController:topMostVisibleViewController animated:animated];
}

- (void)dismissViewController:(UIViewController *)viewController withTransitionStyle:(NSString *)transitionStyle {
    id<MBTransitionStyle> transition = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
    [transition applyTransitionStyleToViewController:viewController forMovement:MBTransitionMovementPush];
    BOOL animated = [transition animated];
    
    [[[MBApplicationController currentInstance] viewManager] dismisViewController:viewController animated:animated];
}

@end
