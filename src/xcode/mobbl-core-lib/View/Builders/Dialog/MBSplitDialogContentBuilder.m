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
