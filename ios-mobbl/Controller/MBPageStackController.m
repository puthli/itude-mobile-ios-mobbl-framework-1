//
//  MBPageStackController.m
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBMacros.h"
#import "MBPageStackController.h"
#import "MBPage.h"
#import "MBActivityIndicator.h"
#import "MBSpinner.h"

#import "MBStyleHandler.h"
#import "MBViewBuilderFactory.h" 
#import "MBBasicViewController.h"
#import "UINavigationController+MBRebuilder.h"
#import "MBViewManager.h"
#import "MBTransitionStyle.h"
#import "MBDialogController.h"

#import <QuartzCore/QuartzCore.h>

@interface MBPageStackController(){
    
	NSString *_name;
	NSString *_title;

	CGRect _bounds;
    UINavigationController *_rootController;
    UINavigationController *_navigationController;
	NSInteger _activityIndicatorCount;
	BOOL _temporary;
}
@property (nonatomic, assign) NSInteger activityIndicatorCount;

-(void) clearSubviews;
-(UINavigationController*) determineNavigationController;
-(UITabBarController*) determineTabBarController;

@end

@implementation MBPageStackController

@synthesize name = _name;
@synthesize title = _title;
@synthesize bounds = _bounds;

@synthesize rootController = _rootController;
@synthesize activityIndicatorCount = _activityIndicatorCount;

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[_name release];
    [_title release];

	[_rootController release];
	[super dealloc];
}

-(id) initWithDefinition:(MBPageStackDefinition *)definition {
	if(self = [super init]) {
		self.name = definition.name;
		self.title = definition.title;

        UINavigationController *controller = [[UINavigationController alloc] init];
		self.rootController = controller;
        [controller release];
        
		self.activityIndicatorCount = 0;
		[self showActivityIndicator];
        [[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:self.rootController.navigationBar];
	}
	return self;
    
}

- (id)initWithDefinition:(MBPageStackDefinition *)definition withDialogController:(MBDialogController *)parent {
    if(self = [self initWithDefinition:definition]) {
        self.dialogController = parent;
	}
	return self;
}

-(id) initWithDefinition:(MBPageStackDefinition*)definition page:(MBPage*) page bounds:(CGRect) bounds {
	if(self = [self initWithDefinition:definition]) {
        MBBasicViewController *controller = (MBBasicViewController*)page.viewController;
        controller.pageStackController = self;
        [self.rootController setRootViewController:page.viewController];
        _bounds = bounds;
	}
	return self;
}



-(void)showPage:(MBPage *)page displayMode:(NSString *)displayMode transitionStyle:(NSString *)transitionStyle {
    
    if(displayMode != nil){
        DLog(@"PageStackController: showPage name=%@ pageStack=%@ mode=%@", page.pageName, _name, displayMode);
	}
    
    page.transitionStyle = transitionStyle;
    
	UINavigationController *nav = [self determineNavigationController];
	
	if([displayMode isEqualToString:@"REPLACE"]) {

        // Replace page controller on the stack
		if (nav.visibleViewController == nav.topViewController) {
            
            [[[MBApplicationFactory sharedInstance] transitionStyleFactory] applyTransitionStyle:transitionStyle withMovement:MBTransitionMovementPush forViewController:nav];
			[nav popViewControllerAnimated:NO];
			[nav setRootViewController:page.viewController];
		}
        // Replace the last page on the stack
		else {
            [[[MBApplicationFactory sharedInstance] transitionStyleFactory] applyTransitionStyle:transitionStyle withMovement:MBTransitionMovementPush forViewController:nav];
			[nav popViewControllerAnimated:NO];
			[nav pushViewController:page.viewController animated:NO];
		}

		return;
	}

    // Apply transitionStyle for a regular page navigation
    id<MBTransitionStyle> style = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
    [style applyTransitionStyleToViewController:nav forMovement:MBTransitionMovementPush];
    
    // Regular navigation to new page
	[nav pushViewController:page.viewController animated:[style animated]];
	
}

-(void)popPageWithTransitionStyle:(NSString *)transitionStyle animated:(BOOL)animated
{
	UINavigationController *nav = [self determineNavigationController];
    
    // Apply transitionStyle for a regular page navigation
    if (transitionStyle) {
        id<MBTransitionStyle> style = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
        [style applyTransitionStyleToViewController:nav forMovement:MBTransitionMovementPop];
        
        // Regular navigation to new page
        animated = [style animated];
    }
    
	[nav popViewControllerAnimated:animated];
}

-(void) doRebuild {
	// Make sure we do this on the foreground! So:
	[self performSelectorOnMainThread:@selector(rebuildPage:) withObject:nil waitUntilDone:NO];
}

-(void) rebuildPage:(id) args {
	id navigationController = [self determineNavigationController];
    
    [navigationController rebuild];
}

-(UITabBarController*)determineTabBarController {
    return [[[MBApplicationController currentInstance] viewManager] tabController];
}

// The following code is really ugly: depending on the time of construction of the pageStack the navigation controller
// might be nil; try a few possibilities:
-(UINavigationController*) determineNavigationController {

//    return [self.rootController.visibleViewController]
    
//	if(_navigationController != nil) return _navigationController;
	
    UITabBarController *tabBarController = [self determineTabBarController];
	if(tabBarController) {
		int idx = [tabBarController.viewControllers indexOfObject:_rootController];
		if(idx >= FIRST_MORE_TAB_INDEX) {
			return tabBarController.moreNavigationController;
		}
	}
    return _rootController;
}

-(void)willActivate {
    NSLog(@"Showing pageStack %@", [self name]);
    
    UINavigationController * navigationController = [self determineNavigationController];
    
	UINavigationBar *morenavbar = navigationController.navigationBar;
    UINavigationItem *morenavitem = morenavbar.topItem;
    // Currently we don't want Edit button in More screen; because we need to store the order then also
	if([self determineTabBarController].moreNavigationController == navigationController) morenavitem.rightBarButtonItem = nil;
}

-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
	// Read issue MOBBL-150 before changing this. 
	// Notify the viewController after the UINavigationControllerDelegate is done loading the view
	[viewController viewWillAppear:animated];

	_navigationController = viewController.navigationController;
    [self willActivate];
}

-(void)didActivate {
    NSLog(@"Did show %@", [self name]);
}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	// Read issue MOBBL-150 before changing this. 
	// Notify the viewController after the UINavigationControllerDelegate has shown the view
	[viewController viewDidAppear:animated];
	_navigationController = viewController.navigationController;
    
    [self didActivate];
}

-(void) clearSubviews {
    for(UIView *vw in [_rootController.view subviews]) {
      [vw removeFromSuperview];  
    } 
}

-(UIView*) view {
	return _rootController.view;
}
-(void) setBounds:(CGRect) bounds {
    _bounds = bounds;
    self.rootController.view.bounds = bounds;
}

- (CGRect) screenBoundsForDisplayMode:(NSString*) displayMode {

    CGRect bounds = _bounds;

    if([displayMode isEqualToString:@"PUSH"]) {
        bounds.size.height -= 44;
    } else if([displayMode isEqualToString:@"REPLACE"] && [_rootController.viewControllers count] > 1) {
        // full screen when page will show
        bounds.size.height += 44;
    } else if([[_rootController viewControllers] count] == 1 && [displayMode isEqualToString:@"POP"]) {
        // full screen when page will show
        bounds.size.height += 44;
    } 
	return bounds;
}

-(void)setRootController:(UINavigationController *)rootController {
    [_rootController release];
    _rootController = [rootController retain];
    _rootController.delegate = self;
    _rootController.title = self.title;
    //_rootController.navigationBarHidden = !_usesNavbar;

}

- (void)showActivityIndicator {

	if(self.activityIndicatorCount == 0) {
		// determine the maximum bounds of the screen
		CGRect bounds = [UIScreen mainScreen].applicationFrame;	
		MBActivityIndicator *blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];
		[_rootController.parentViewController.view addSubview:blocker];
	}
	self.activityIndicatorCount ++;

}

- (void)hideActivityIndicator {
	if(self.activityIndicatorCount > 0) {
		self.activityIndicatorCount--;
		
		if(self.activityIndicatorCount == 0) {
			UIView *top = [_rootController.parentViewController.view.subviews lastObject];
			if ([top isKindOfClass:[MBActivityIndicator class]])
				[top removeFromSuperview];
		}
	}

}

- (NSString *)dialogName {
    return self.dialogController.name;
}

@end
