//
//  MBBasicViewController.m
//  Core
//
//  Created by Wido on 6/2/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

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
