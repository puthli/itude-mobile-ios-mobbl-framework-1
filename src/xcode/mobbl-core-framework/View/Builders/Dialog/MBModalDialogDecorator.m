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

#import "MBModalDialogDecorator.h"
#import "MBDialogController.h"
#import "MBPageStackController.h"
#import "MBLocalizationService.h"

@interface MBModalDialogDecorator ()
@property (nonatomic, retain) NSString *originPageStackName;
@end

@implementation MBModalDialogDecorator

- (void)dealloc
{
    [_originPageStackName release];
    [super dealloc];
}

- (void)decorateDialog:(MBDialogController *)dialog {
    // Default modal behaviour
}


-(void)presentDialog:(MBDialogController *)dialog withTransitionStyle:(NSString *)transitionStyle{

	// Store the pageStackName of tge pageStack that was visible before this modal is presented
	self.originPageStackName =  [[[[MBApplicationController currentInstance] viewManager] dialogManager] activePageStackName];

	UIViewController *viewController = dialog.rootViewController;
	id<MBTransitionStyle> transition = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
	[transition applyTransitionStyleToViewController:viewController forMovement:MBTransitionMovementPush];
	BOOL animated = [transition animated];
	UIViewController *topMostVisibleViewController = [[[MBApplicationController currentInstance] viewManager] topMostVisibleViewController];

	// Pjotter: I have absolutely no idea why this needs to be dispatched async when queue starting this is the main queue.. O_o
	//  Works perfectly fine without the dispatch if called from a different queue (even if it is the main thread), or when running iOS 6 instead of 7
	dispatch_async(dispatch_get_main_queue(), ^{
		[[[MBApplicationController currentInstance] viewManager] presentViewController:viewController fromViewController:topMostVisibleViewController animated:animated ];
	});
}

-(void)dismissDialog:(MBDialogController *)dialog withTransitionStyle:(NSString *)transitionStyle {
    UIViewController *viewController = dialog.rootViewController;
    id<MBTransitionStyle> transition = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
    [transition applyTransitionStyleToViewController:viewController forMovement:MBTransitionMovementPop];
    BOOL animated = [transition animated];
    
    [[[MBApplicationController currentInstance] viewManager] dismisViewController:viewController animated:animated completion:^{
		[dialog resetView];
	}];

    // We want to activate the pageStack that was visible before the modal was presented
    [[[[MBApplicationController currentInstance] viewManager] dialogManager] activatePageStackWithName:self.originPageStackName];
}

@end
