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

#import "MBBasicViewController.h"
#import "MBPage.h"
#import "MBOrientationManager.h"
#import "MBPageStackController.h"
#import "MBDialogController.h"
#import "MBViewBuilderFactory.h"

// Adds rotation support
#import "UIViewController+Rotation.h"
#import "UIViewController+Layout.h"

@interface MBBasicViewController () {
    MBPage *_page;
    MBPageStackController *_pageStackController;
}

@end

@implementation MBBasicViewController

@synthesize page = _page;
@synthesize pageStackController = _pageStackController;

- (void) dealloc
{
    [_page release];
    [_pageStackController release];
    [super dealloc];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackButton];
    
    [self setupLayoutForIOS7];
}

-(void) handleException:(NSException *) exception{
	[self.page handleException:exception];
}

- (void) rebuildView {
	[self.page rebuildView];	
}

-(void) showActivityIndicator {
	[[MBApplicationController currentInstance] showActivityIndicator];
}

-(void) hideActivityIndicator {
	[[MBApplicationController currentInstance] hideActivityIndicator];
}

// Setup a custom backbutton when a builder is registred
-(void)setupBackButton {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers count] > 1) {
        UIViewController *previousViewController = [viewControllers objectAtIndex:[viewControllers count]-2];
        UIBarButtonItem *backButton = [[[MBViewBuilderFactory sharedInstance] backButtonBuilderFactory] buildBackButtonWithTitle:previousViewController.navigationItem.title];
        if (backButton) {
            [self.navigationItem setLeftBarButtonItem:backButton animated:NO];
        }
    }
}

#pragma mark -
#pragma mark View lifecycle delegate methods

-(void) viewDidAppear:(BOOL)animated {
	for (id childView in [self.view subviews]){
		if ([childView respondsToSelector:@selector(delegate)]) {
			id delegate = [childView delegate];
			if(delegate != self && [delegate respondsToSelector:@selector(viewDidAppear:)]) [delegate viewDidAppear:animated];
		}
	}
}

-(void) viewWillAppear:(BOOL)animated {
	for (id childView in [self.view subviews]){
		if ([childView respondsToSelector:@selector(delegate)]) {
			id delegate = [childView delegate];
			if(delegate != self && [delegate respondsToSelector:@selector(viewWillAppear:)]) [delegate viewWillAppear:animated];
		}
	}
}

-(void) viewDidDisappear:(BOOL)animated {
	for (id childView in [self.view subviews]){
		if ([childView respondsToSelector:@selector(delegate)]) {
			id delegate = [childView delegate];
			if(delegate != self){
				//if ([delegate respondsToSelector:@selector(viewDidDisappear:)]) {
				[delegate viewDidDisappear:animated];
				//}
			}
		}
	}
}

-(void) viewWillDisappear:(BOOL)animated {
	for (id childView in [self.view subviews]){
		if ([childView respondsToSelector:@selector(delegate)]) {
			id delegate = [childView delegate];
			if(delegate != self ){//&& [delegate respondsToSelector:@selector(viewWillDisappear:)]) {
				[delegate viewWillDisappear:animated];
			}
		}
	}
}


@end
