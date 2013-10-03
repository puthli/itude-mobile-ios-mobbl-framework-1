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

#import "MBNavigationController.h"
#import "MBBasicViewController.h"

@interface MBNavigationController()
-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated fireAppearEvents:(BOOL) fireAppearEvents fireDisappearEvents:(BOOL)fireDisappearEvents;
@end


@implementation MBNavigationController

@synthesize fakeRootViewController;
@synthesize viewWillAppearFirstCall = _viewWillAppearFirstCall;
@synthesize viewDidAppearFirstCall = _viewDidAppearFirstCall;

//override the standard init
-(id)initWithRootViewController:(UIViewController *)rootViewController {
	// Create the fake controller and set it as the root
    // Use a MBBasicViewController so we can modify the behaviour of rotation in iOS 5.1. If we don't and we replace the rootViewcontroller it will go to the default rotation (Portrait)
    MBBasicViewController *fakeController = [[[MBBasicViewController alloc] init] autorelease];
	if (self = [super initWithRootViewController:fakeController]) {
		// These ar for issue MOBBL-150. See issue for more information before changing anything.
		// If the application starts, the viewWillAppear and viewDidAppear methods are called 
		// once by the MBNavigationController (after setting the Dialog(Group)Controllers in the MBViewManager) and
		// once by the DialogController will/didShowViewController.
		// To counter this effect, we disable the first call with these booleans in the local viewWillAppear and ViewDidAppear methods
		_viewWillAppearFirstCall = YES;
		_viewDidAppearFirstCall = YES;
		
		self.fakeRootViewController = fakeController;
		//hide the back button on the perceived root
		rootViewController.navigationItem.hidesBackButton = YES;
		//push the perceived root (at index 1)
		[self pushViewController:rootViewController animated:NO fireAppearEvents: NO fireDisappearEvents:NO];
	}
	return self;
}

-(void) rebuild {
	NSArray *controllers = [NSArray arrayWithArray:[self viewControllers]];

	[self popToViewController:self.fakeRootViewController animated:NO];
	for(MBBasicViewController *ctrl in controllers) {
		if([ctrl respondsToSelector:@selector(rebuildView)]) [ctrl rebuildView];
		   
		// To avoid superfluious apper/disappear call the super; not self:
		[super pushViewController:ctrl animated:NO];
	}
}

//override to remove fake root controller
-(NSArray *)viewControllers {
    NSArray *viewControllers = [super viewControllers];
	if (viewControllers != nil && viewControllers.count > 0) {
		NSMutableArray *array = [NSMutableArray arrayWithArray:viewControllers];
		[array removeObjectAtIndex:0];
		return array;
	}
	return viewControllers;
}

//set the view controllers in the stack
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
	
	NSMutableArray *newViewControllers = [NSMutableArray arrayWithObject:[[super viewControllers] objectAtIndex:0]];
	
	[newViewControllers addObjectsFromArray:viewControllers];
	
	[super setViewControllers:newViewControllers animated:animated];	
}

//override so it pops to the perceived root
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    //we use index 0 because we overrided “viewControllers”
	if ([self.viewControllers count]>0) {
		return [self popToViewController:[self.viewControllers objectAtIndex:0] animated:animated];
	}
	else{
		return nil;
	}
}

//this is the new method that lets you set the perceived root, the previous one will be popped (released)
-(void)setRootViewController:(UIViewController *)rootViewController {
    rootViewController.navigationItem.hidesBackButton = YES;
    [self popToViewController:fakeRootViewController animated:NO];
    [self pushViewController:rootViewController animated:NO];
}

// Read issue MOBBL-150 before changing this method
-(UIViewController *) popViewControllerAnimated:(BOOL)animated {
	if([[self viewControllers] count] > 0)
	{
		[[[self viewControllers] lastObject] viewWillDisappear:animated];
		[[[self viewControllers] lastObject] viewDidDisappear:animated];
	}
	
	UIViewController *result = [super popViewControllerAnimated:animated];

	UIViewController *currentlyVisible = nil;
	
	if([[self viewControllers] count] > 0) {currentlyVisible = [[self viewControllers] lastObject];
		[currentlyVisible viewWillAppear:animated];	
		[currentlyVisible viewDidAppear:animated];
	}
	
	return result;
}

// Because the delegate of this navigationcontroller is set; we need to manage the view(dis)appear events ourselves:
-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	// Read issue MOBBL-150 before changing this methodcall
	// We don't want to fire the appearEvents because we want the UINavigationControllerDelegate in the MBDialogController handle these view delegate calls
	[self pushViewController:viewController animated:animated fireAppearEvents: NO fireDisappearEvents:YES];
}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated fireAppearEvents:(BOOL) fireAppearEvents fireDisappearEvents:(BOOL) fireDisappearEvents{
	UIViewController *currentlyVisible = nil;
	
	if([[self viewControllers] count] > 0) currentlyVisible = [[self viewControllers] lastObject];
	if(fireDisappearEvents) [currentlyVisible viewWillDisappear:animated];
	if(fireAppearEvents) [viewController viewWillAppear:animated];	
	[super pushViewController:viewController animated:animated];
	if(fireDisappearEvents) [currentlyVisible viewDidDisappear:animated];	
	if(fireAppearEvents) [viewController viewDidAppear:animated];	
}

// This is a workaround; for some reason the children do not always get an appear / disappear callback after a [dialogController rebuildPage] call
// Do NOT CALL THE SUPER METHOD: if we do the children might get it twice
// TODO: figure out what is going on; delegate related?
-(void) viewDidAppear:(BOOL)animated {
	// This is a fix for releasing 1.1.1 
	// It causes the viewDidAppear to be called twice for the first controllers that are displayed
	// It solves that the viewDidAppear was not called for modal viewControllers
	_viewDidAppearFirstCall = NO;	
	
	// This is for issue MOBBL-150. See issue for more information before changing anything.
	// If the application starts, the viewWillAppear and viewDidAppear methods are called 
	// once by the MBNavigationController (after setting the Dialog(Group)Controllers in the MBViewManager) and
	// once by the DialogController will/didShowViewController.
	// To counter this effect, we disable the first call with these booleans in the local viewWillAppear and ViewDidAppear methods
	if (!_viewDidAppearFirstCall && ([[self viewControllers] count] > 0)) [[[self viewControllers] lastObject] viewDidAppear:animated];
	_viewDidAppearFirstCall = NO;	
}

-(void) viewDidDisappear:(BOOL)animated {
	if([[self viewControllers] count] > 0)[[[self viewControllers] lastObject] viewDidDisappear:animated];	
}

-(void) viewWillAppear:(BOOL)animated {
	// This is a fix for releasing 1.1.1 
	// It causes the viewWillAppear to be called twice for the first controllers that are displayed
	// It solves that the viewWillAppear was not called for modal viewControllers
	_viewWillAppearFirstCall = NO;
	
	// This is for issue MOBBL-150. See issue for more information before changing anything.
	// If the application starts, the viewWillAppear and viewDidAppear methods are called 
	// once by the MBNavigationController (after setting the Dialog(Group)Controllers in the MBViewManager) and
	// once by the DialogController will/didShowViewController.
	// To counter this effect, we disable the first call with these booleans in the local viewWillAppear and ViewDidAppear methods
	if (!_viewWillAppearFirstCall && ([[self viewControllers] count] > 0)) [[[self viewControllers] lastObject] viewWillAppear:animated];
	_viewWillAppearFirstCall = NO;
}

-(void) viewWillDisappear:(BOOL)animated {
	if([[self viewControllers] count] > 0)[[[self viewControllers] lastObject] viewWillDisappear:animated];	
}

- (void)dealloc {
    self.fakeRootViewController = nil;
    [super dealloc];
}

@end

