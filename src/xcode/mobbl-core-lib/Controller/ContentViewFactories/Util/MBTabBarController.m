/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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

//  MBTabBarController.m
//  itude-mobile-ios-chep-uld
//  Created by Frank van Eenbergen on 06/01/14.

#import "MBTabBarController.h"
#import "MBDialogController.h"
#import "MBLocalizationService.h"
#import "MBResourceService.h"
#import "MBPageStackController.h"
#import "MBViewBuilderFactory.h"
#import "MBBasicViewController.h"

@implementation MBTabBarController


#pragma mark -
#pragma mark - MBTabBarControllerDelegate

- (void)makeKeyAndVisible {
	[self.moreNavigationController popToRootViewControllerAnimated:NO];
}

- (NSInteger)selectedTabIndex {
    return self.selectedIndex;
}

- (void)selectTabAtIndex:(NSInteger)index {
    [self setSelectedIndex:index];
}

- (void)didActivatePageStack:(MBPageStackController *)pageStackController inDialog:(MBDialogController *)dialogController {
    // If we have more than one viewController visible
    if (self) {
		dispatch_async(dispatch_get_main_queue(), ^{
			// Only set the selected tab if realy necessary; because it messes up the more navigation controller
			NSInteger idx = self.selectedIndex;
			NSInteger shouldBe = [self.viewControllers indexOfObject: dialogController.rootViewController];
			
			if(idx != shouldBe && shouldBe!=NSNotFound) {
				[self setSelectedIndex:shouldBe];
			}
		});
    }
}

#pragma mark -
#pragma mark UITabBarControllerDelegate

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	return YES;
}

// Method is called when the tabBar will be edited by the user (when the user presses the edid-button on the more-page).
// It is used to update the style of the "Edit" navigationBar behind the Edit-button
- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
	// Get the navigationBar from the edit-view behind the more-tab and apply style to it.
    UINavigationBar *navBar = [[[tabBarController.view.subviews objectAtIndex:1] subviews] objectAtIndex:0];
	[[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:navBar];
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    MBDialogManager *dialogManager = [[[MBApplicationController currentInstance] viewManager] dialogManager];
    
    // Set active dialog/pageStack name
    for (MBDialogController *dialogController in [dialogManager.dialogControllers allValues]) {
        if (viewController == dialogController.rootViewController) {
            if ([viewController isKindOfClass:[MBBasicViewController class]]) {
                MBBasicViewController *basicViewController = (MBBasicViewController*)viewController;
                [dialogManager activatePageStackWithName:basicViewController.pageStackController.name];
            }
            else {
                [dialogManager activateDialogWithName:dialogController.name];
            }
            break;
        }
    }
}

@end
