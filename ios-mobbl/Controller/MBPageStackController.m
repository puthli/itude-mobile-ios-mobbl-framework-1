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
@synthesize navigationController = _navigationController;
@synthesize activityIndicatorCount = _activityIndicatorCount;

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[_name release];
    [_title release];
    //[_navigationController release];
	[super dealloc];
}

-(id) initWithDefinition:(MBPageStackDefinition *)definition {
	if(self = [super init]) {
		self.name = definition.name;
		self.title = definition.title;
		self.navigationController = [[UINavigationController new] autorelease];
		self.activityIndicatorCount = 0;
		[self showActivityIndicator];
        [[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:self.navigationController.navigationBar];
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
        [self.navigationController setRootViewController:page.viewController];
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
	
    // Apply transitionStyle for a regular page navigation
    id<MBTransitionStyle> style = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
    [style applyTransitionStyleToViewController:nav forMovement:MBTransitionMovementPush];
    
    // Replace the last page on the stack
	if([displayMode isEqualToString:@"REPLACE"]) {
        [nav replaceLastViewController:page.viewController];
		return;
	}
    
    // Regular navigation to new page
    else {
        [nav pushViewController:page.viewController animated:[style animated]];
    }
	
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
		int idx = [tabBarController.viewControllers indexOfObject:self.navigationController];
		if(idx != NSNotFound && idx >= FIRST_MORE_TAB_INDEX) {
			return tabBarController.moreNavigationController;
		}
	}
    return self.navigationController;
}

-(void)willActivate {
    DLog(@"Will show pageStackController with name %@", [self name]);
    
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

    [self willActivate];
}

-(void)didActivate {
    DLog(@"Did show pageStackController with name %@", [self name]);
}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	// Read issue MOBBL-150 before changing this. 
	// Notify the viewController after the UINavigationControllerDelegate has shown the view
	[viewController viewDidAppear:animated];
	_navigationController = viewController.navigationController;
    
    [self didActivate];
}

-(void) clearSubviews {
    for(UIView *vw in [self.navigationController.view subviews]) {
      [vw removeFromSuperview];  
    } 
}

-(UIView*) view {
	return self.navigationController.view;
}
-(void) setBounds:(CGRect) bounds {
    _bounds = bounds;
    self.navigationController.view.bounds = bounds;
}

- (CGRect) screenBoundsForDisplayMode:(NSString*) displayMode {

    CGRect bounds = _bounds;

    if([displayMode isEqualToString:@"PUSH"]) {
        bounds.size.height -= 44;
    } else if([displayMode isEqualToString:@"REPLACE"] && [self.navigationController.viewControllers count] > 1) {
        // full screen when page will show
        bounds.size.height += 44;
    } else if([[self.navigationController viewControllers] count] == 1 && [displayMode isEqualToString:@"POP"]) {
        // full screen when page will show
        bounds.size.height += 44;
    } 
	return bounds;
}

-(void)setNavigationController:(UINavigationController *)navigationController {
    [_navigationController release];
    _navigationController = [navigationController retain];
    _navigationController.delegate = self;
    _navigationController.title = self.title;
}

- (void)showActivityIndicator {

	if(self.activityIndicatorCount == 0) {
		// determine the maximum bounds of the screen
		CGRect bounds = [UIScreen mainScreen].applicationFrame;	
		MBActivityIndicator *blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];
		[_navigationController.parentViewController.view addSubview:blocker];
	}
	self.activityIndicatorCount ++;

}

- (void)hideActivityIndicator {
	if(self.activityIndicatorCount > 0) {
		self.activityIndicatorCount--;
		
		if(self.activityIndicatorCount == 0) {
			UIView *top = [_navigationController.parentViewController.view.subviews lastObject];
			if ([top isKindOfClass:[MBActivityIndicator class]])
				[top removeFromSuperview];
		}
	}

}

- (NSString *)dialogName {
    return self.dialogController.name;
}

@end
