//
//  MBDialogController.m
//  Core
//
//  Created by Wido on 28-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBMacros.h"
#import "MBDialogController.h"
#import "MBPage.h"
#import "MBActivityIndicator.h"
#import "MBNavigationController.h"
#import "MBSpinner.h"
// Used to get a stylehandler to style navigationBar
#import "MBStyleHandler.h"
#import "MBViewBuilderFactory.h" 
#import "MBBasicViewController.h"

@interface MBDialogController()
	-(void) clearSubviews;
    -(UINavigationController*) determineNavigationController;

@end

@implementation MBDialogController

@synthesize name = _name;
@synthesize iconName = _iconName;
@synthesize title = _title;
@synthesize bounds = _bounds;
@synthesize dialogMode = _dialogMode;
@synthesize dialogGroupName = _dialogGroupName;
@synthesize position = _position;
@synthesize rootController = _rootController;
@synthesize temporary = _temporary;

-(id) initWithDefinition:(MBDialogDefinition*)definition temporary:(BOOL) isTemporary {
	if(self = [super init]) {
		self.name = definition.name;
		self.title = definition.title;
        self.dialogMode = definition.mode;
		self.dialogGroupName = definition.groupName;
		self.position = definition.position;
        UINavigationController *controller = [[UINavigationController alloc] init];
		self.rootController = controller;
        [controller release];
		self.rootController.title = self.title;
		self.temporary = isTemporary;
		_usesNavbar = FALSE;
		_activityIndicatorCount = 0;
		[self showActivityIndicator];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRebuild) name:REBUILD_DIALOG_NOTIFICATION object:nil];
	}
	return self;	
}

-(id) initWithDefinition:(MBDialogDefinition*)definition page:(MBPage*) page bounds:(CGRect) bounds {
	if(self = [super init]) {
		self.name = definition.name;
		self.title = definition.title;
        self.dialogMode = definition.mode;
		//self.dialogGroupName = definition.groupName;
		self.temporary = FALSE;

        _bounds = bounds;
		
        MBNavigationController *controller = [[MBNavigationController alloc] initWithRootViewController:page.viewController];
		self.rootController = controller;
        [controller release];
		self.rootController.delegate = self;
		self.rootController.title = self.title;
		_usesNavbar = [definition.mode isEqualToString:@"STACK"];
		_activityIndicatorCount = 0;
		self.rootController.navigationBarHidden = !_usesNavbar;
		
		// Apply style to the navigationbar
		[[[MBViewBuilderFactory sharedInstance] styleHandler] styleNavigationBar:self.rootController.navigationBar];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRebuild) name:REBUILD_DIALOG_NOTIFICATION object:nil];
	}
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[_name release];
	[_iconName release];
	[_dialogMode release];
	[_dialogGroupName release];
	[_rootController release];
	[super dealloc];
}

-(void) showPage:(MBPage*) page displayMode:(NSString*) displayMode {
    
    if(displayMode != nil){
        DLog(@"DialogController: showPage name=%@ dialog=%@ mode=%@", page.pageName, _name, displayMode);
	}
	UINavigationController *nav = [self determineNavigationController];
	
	
	if([displayMode isEqualToString:@"REPLACE"]) {

		// If the rootController is popped, there is no controller to go back to. 
		// A black screen will be displayed when the user navigates back! That is why we need to replace it
		if ((nav.visibleViewController == nav.topViewController)&& 
			[nav isKindOfClass:[MBNavigationController class]]) {
			MBNavigationController *mbNav = (MBNavigationController *)nav;
			[mbNav popViewControllerAnimated:FALSE];
			[mbNav setRootViewController:page.viewController];
		}
		else {
			[nav popViewControllerAnimated:FALSE];
			[nav pushViewController:page.viewController animated:FALSE];
		}

		return;
	}
    //redundant pop 
//	else if([displayMode isEqualToString:@"POP"]) {		
//		[nav popViewControllerAnimated:FALSE];
//	}

	[nav pushViewController:page.viewController animated:YES];
	
}

-(void) popPageAnimated:(BOOL) animated {
	UINavigationController *nav = [self determineNavigationController];
	[nav popViewControllerAnimated:animated];
}

-(void) doRebuild {
	// Make sure we do this on the foreground! So:
	[self performSelectorOnMainThread:@selector(rebuildPage:) withObject:nil waitUntilDone:NO];
}

-(void) rebuildPage:(id) args {
	id navigationController = [self determineNavigationController];
	
	if([navigationController isKindOfClass:[MBNavigationController class]]) {
		MBNavigationController *nc = (MBNavigationController*) navigationController;
		[nc rebuild];
	}
	else if([navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
			NSMutableArray *ctrls = [[NSMutableArray new] autorelease];
			
			UIViewController *ctrl;
			do { ctrl = [navigationController popViewControllerAnimated:NO];
				if(ctrl != nil)  {
					[ctrls addObject:ctrl]; 
					if([ctrl isKindOfClass:[MBBasicViewController class]]) {
						MBBasicViewController *basic = (MBBasicViewController*) ctrl;
						[basic rebuildView];
					}
				}
			} while(ctrl != nil);
			
			for(int i=[ctrls count]-1; i>=0; i--) {
				[navigationController pushViewController: [ctrls objectAtIndex:i] animated: NO];
			}
			if([ctrls count] == 0) {
				// Workaround; this is probably the case when the more navigation controller is not touched yet
				// resort to using the rootcontroller
				if([_rootController isKindOfClass:[MBNavigationController class]]) {
					MBNavigationController *nav = (MBNavigationController*) _rootController;
					[nav rebuild];
				}
			}
		}
	else {
		WLog(@"WARNING: Do not know how to rebuild a %@; navigation stack not refreshed", [navigationController class]);
	}

	
}

// The following code is really ugly: depending on the time of construction of the dialog the navigation controller
// might be nil; try a few possibilities:
-(UINavigationController*) determineNavigationController {

	if(_navigationController != nil) return _navigationController;
	
	if(_rootController.tabBarController) {
		int idx = [_rootController.tabBarController.viewControllers indexOfObject:_rootController];
		if(idx >= FIRST_MORE_TAB_INDEX) {
			return _rootController.tabBarController.moreNavigationController;
		}
	}
	return _rootController;
}

-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	// Read issue MOBBL-150 before changing this. 
	// Notify the viewController after the UINavigationControllerDelegate is done loading the view
	[viewController viewWillAppear:animated];
	
	UINavigationBar *morenavbar = navigationController.navigationBar;
    UINavigationItem *morenavitem = morenavbar.topItem;
    // Currently we don't want Edit button in More screen; because we need to store the order then also
	if(_rootController.tabBarController.moreNavigationController == navigationController) morenavitem.rightBarButtonItem = nil;

	_navigationController = viewController.navigationController;
}

-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	// Read issue MOBBL-150 before changing this. 
	// Notify the viewController after the UINavigationControllerDelegate has shown the view
	[viewController viewDidAppear:animated];
	
	_navigationController = viewController.navigationController;
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

- (void)showActivityIndicator {

	if(_activityIndicatorCount == 0) {
		// determine the maximum bounds of the screen
		CGRect bounds = [UIScreen mainScreen].applicationFrame;	
		//CGRect activityInset = CGRectInset(bounds, (bounds.size.width - 24) / 2, (bounds.size.height - 24) / 2);
		
		MBActivityIndicator *blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];
		/*
		UIActivityIndicatorView *aiv = [[[UIActivityIndicatorView alloc] initWithFrame:activityInset] autorelease];
		[aiv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		[aiv startAnimating];
		
		[blocker addSubview:aiv];
		 */
		[_rootController.parentViewController.view addSubview:blocker];
	}
	_activityIndicatorCount ++;
 
	
	//[[MBSpinner sharedInstance] showActivityIndicator:_rootController.parentViewController.view];
}

- (void)hideActivityIndicator {
	if(_activityIndicatorCount > 0) {
		_activityIndicatorCount--;
		
		if(_activityIndicatorCount == 0) {
			UIView *top = [_rootController.parentViewController.view.subviews lastObject];
			if ([top isKindOfClass:[MBActivityIndicator class]])
				[top removeFromSuperview];
		}
	}
 
	//[[MBSpinner sharedInstance] hideActivityIndicator:_rootController.parentViewController.view];
}

@end
