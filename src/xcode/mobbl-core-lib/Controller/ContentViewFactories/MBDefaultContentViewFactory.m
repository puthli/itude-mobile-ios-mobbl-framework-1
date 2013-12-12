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

//  MBDefaultContentViewFactory.m
//  mobbl-core-lib
//  Created by Pjotter Tommassen on 2013/12/12.

#import "MBDefaultContentViewFactory.h"
#import "MBDialogController.h"
#import "MBResourceService.h"
#import "MBLocalizationService.h"
#import "MBViewBuilderFactory.h"

@implementation MBDefaultContentViewFactory
-(UIViewController*)createContentView:(NSArray *)dialogControllers  forViewManager:(MBViewManager*)viewManager{

	UIViewController *result = nil;
    MBDialogController *firstDialogController = nil;
    // Should create tabbar
    if([dialogControllers count] > 1 && [self shouldCreateTabBarForDialogsControllers:dialogControllers])
	{
		UITabBarController *tabController = [[[UITabBarController alloc] init] autorelease];

        // Build the tabs
        int idx = 0;
        NSMutableArray *tabs = [NSMutableArray new];
        for (MBDialogController *dialogController in dialogControllers) {
            if ([dialogController showAsTab]) {
                // Create a tabbarProperties
                UIViewController *viewController = dialogController.rootViewController;
                UIImage *tabImage = [[MBResourceService sharedInstance] imageByID: dialogController.iconName];
                NSString *tabTitle = MBLocalizedString(dialogController.title);
                UITabBarItem *tabBarItem = [[[UITabBarItem alloc] initWithTitle:tabTitle image:tabImage tag:idx] autorelease];
                viewController.tabBarItem = tabBarItem;

                [tabs addObject:viewController];

                if (idx == 0) {
                    firstDialogController = dialogController;
                }

                idx ++;
            }
        }

        // Set the tabs to the tabbar
        [tabController setViewControllers: tabs animated: YES];
        [[tabController moreNavigationController] setHidesBottomBarWhenPushed:FALSE];
		tabController.delegate = viewManager;
        tabController.moreNavigationController.delegate = viewManager;
        tabController.customizableViewControllers = nil;
        [tabs release];

        [[[MBViewBuilderFactory sharedInstance] styleHandler] styleTabBarController:tabController];

		result = tabController;
    }

    // Single page mode
    else if([dialogControllers count] > 0) {

        // Search for the only dialogController with attribute 'showAs="TAB"'.
		MBDialogController *dialogController = nil;
		for (MBDialogController *currentDialogContoller in dialogControllers) {
			if ([currentDialogContoller showAsTab]) {
				dialogController = currentDialogContoller;
				break;
			}
		}

		// Take the first dialogController if no dialogController with attribute 'showAs="TAB"' is found.
		if (!dialogController) {
			dialogController = [dialogControllers objectAtIndex:0];
		}

		result = dialogController.rootViewController;
		firstDialogController = dialogController;
    }

	return result;
}

- (BOOL)shouldCreateTabBarForDialogsControllers:(NSArray *)dialogControllers {
    NSInteger numberOfShowAsTabs = 0;
    for (MBDialogController *dialogController in dialogControllers) {
        if ([dialogController showAsTab]) {
            numberOfShowAsTabs ++;
            if (numberOfShowAsTabs > 1) {
                return YES;
            }
        }
    }
    return NO;
}
@end
