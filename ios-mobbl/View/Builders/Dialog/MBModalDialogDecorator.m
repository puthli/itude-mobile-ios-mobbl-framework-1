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

#import "MBModalDialogDecorator.h"
#import "MBDialogController.h"
#import "MBPageStackController.h"
#import "MBLocalizationService.h"

@implementation MBModalDialogDecorator

- (void)decorateDialog:(MBDialogController *)dialog {
   if (dialog.addCloseButton) {
       [self addCloseButtonToDialog:dialog];
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

- (void)addCloseButtonToDialog:(MBDialogController *)dialog {
    UIViewController *viewController = dialog.rootViewController;
    NSString *closeButtonTitle = MBLocalizedString(@"closeButtonTitle");
    // TODO: We need to use dismissDialog: transitionStyle: instead of endModalPageStack
    id delegate = [[MBApplicationController currentInstance] viewManager];
    UIBarButtonItem *closeButton = [[[UIBarButtonItem alloc] initWithTitle:closeButtonTitle style:UIBarButtonItemStyleBordered target:delegate action:@selector(endModalPageStack)] autorelease];
    [viewController.navigationItem setRightBarButtonItem:closeButton animated:YES];
}

@end
