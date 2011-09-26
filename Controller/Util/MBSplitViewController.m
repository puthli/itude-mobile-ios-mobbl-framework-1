//
//  MBSplitViewController.m
//  Core
//
//  Created by Frank van Eenbergen on 10/20/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBSplitViewController.h"
#import "MBViewBuilderFactory.h"
#import "MBStyleHandler.h"
#import "MBOrientationManager.h"


@implementation MBSplitViewController

@synthesize keepLeftViewControllerVisibleInPortraitMode = _keepLeftViewControllerVisibleInPortraitMode;

-(void) initialize { 
	self.delegate = self;
	self.notifyChildViewControllersOfViewLifecycleDelegateMethodCalls = NO;
}	

#pragma mark -
#pragma mark init-methods

// It is possible to keep the Master View in portrait mode. Just pass YES to this method to enable this mode.
- (id) initWithLeftViewControllerVisibleInPortraitMode:(BOOL) visible {
	if (self = [super init]) {
		[self initialize];
		self.keepLeftViewControllerVisibleInPortraitMode = visible;
		self.showsMasterInPortrait = visible;
	}
	return self;
}

- (id) init
{
	if (self = [super init]) {
		[self initialize];
	}
	return self;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self initialize];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void) reloadViewControllers {
	UIInterfaceOrientation interfaceOrientation = [self interfaceOrientation];
	[self reloadViewControllers:interfaceOrientation];
}

- (void) reloadViewControllers:(UIInterfaceOrientation) interfaceOrientation {
	
	// Check interface orientation at first view and adjust it when the left ViewController has to stay visible
	if(self.keepLeftViewControllerVisibleInPortraitMode) {
		
		UIViewController* leftViewController = [self.viewControllers objectAtIndex:0];
		UIViewController* rightViewController = [self.viewControllers objectAtIndex:1];
		
		// Setup portrait mode
		if(interfaceOrientation == UIInterfaceOrientationPortrait || 
		   interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			CGRect f = leftViewController.view.frame;
			f.size.width = 320;
			// TODO: This causes the issue for the height! FIX!
			//f.size.height = self.view.frame.size.height;
			f.origin.x = 0;
			f.origin.y = 0;
			//[leftViewController.view setFrame:f];
			
			f = rightViewController.view.frame;
			f.size.width = 448;
			// TODO: This causes the issue for the height! FIX!
			//f.size.height = self.view.frame.size.height;
			f.origin.x = 321;
			f.origin.y = 0;
			//[rightViewController.view setFrame:f];
		}
		
		// Setup landscape mode
		else {
			CGRect f = rightViewController.view.frame;
			f.size.width = 704;
			// TODO: This is going to mess up the height of the dialog controllers in portrait. Not tested yet. Probably fix!
			//f.size.height = 768;
			f.origin.x = 321;
			f.origin.y = 0;			
			[rightViewController.view setFrame:f];
		}
	}
}


#pragma mark -
#pragma mark Viewmanaging and -lifecycle methods

// Make sure the splitViewcontroller is resized to fit inside the frame and the tabbarControler does not obscure
// Note: I had to modify the MGSplitViewController to override this method 
-(CGSize) splitViewSizeForOrientation:(UIInterfaceOrientation)theOrientation {
	CGSize splitViewSize = [super splitViewSizeForOrientation:theOrientation];
	
	// If the splitViewController is nested inside a tabbar, make sure it doesn't obscure that
	if (self.tabBarItem) splitViewSize.height -= self.tabBarController.tabBar.frame.size.height;
	
	splitViewSize = [[[MBViewBuilderFactory sharedInstance] styleHandler] sizeForSplitViewController:self];
	
	return splitViewSize;
}

// For some reason, the splitViewController does not call the viewDelegateMethods on both it's child viewControllers.
// If we call the super, only the right viewController will get notified, 
// so DONT CALL SUPER BECAUSE WE WANT CONTROL OVER THE VIEW DELEGATE METHOD CALLS. The MGSplitViewController has behaviour that we don't want.
// MOBBL-150
-(void) viewWillAppear:(BOOL)animated {
	for (UIViewController *childViewController in self.viewControllers) {
		[childViewController viewWillAppear:animated];
	}
}

-(void) viewWillDisappear:(BOOL)animated {
	for (UIViewController *childViewController in self.viewControllers) {
		[childViewController viewWillDisappear:animated];
	}
}

- (void) viewDidAppear:(BOOL)animated {
	for (UIViewController *childViewController in self.viewControllers) {
		[childViewController viewDidAppear:animated];
	}
}

- (void) viewDidDisappear:(BOOL)animated {
	for (UIViewController *childViewController in self.viewControllers) {
		[childViewController viewDidDisappear:animated];
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
	return [MBOrientationManager supportInterfaceOrientation:interfaceOrientation];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval) duration {
	[self reloadViewControllers:interfaceOrientation];
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

/*
#pragma mark -
#pragma mark SplitViewControllerDelegate methods
// Called when the orientation changes from portrait to landscape. Menu will appear at the left of the screen
- (void) splitViewController:(UISplitViewController *)svc 
	  willShowViewController:(UIViewController *)aViewController 
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	//NSLog(@"Orientation changed from portrait to landscape.");
}

// Called when the orientation changes from landscape to portrait. Menu will disappear from the left of the screen
- (void) splitViewController:(UISplitViewController *)svc 
	  willHideViewController:(UIViewController *)aViewController 
		   withBarButtonItem:(UIBarButtonItem *)barButtonItem 
		forPopoverController:(UIPopoverController *)pc {
	//NSLog(@"Orientation changed from landscape to portrait.");
}

// Called when the MenuViewController will be displayed in a popover
-(void) splitViewController:(UISplitViewController *)svc 
		  popoverController:(UIPopoverController *)pc 
  willPresentViewController:(UIViewController *)aViewController {
	
}
*/

@end
