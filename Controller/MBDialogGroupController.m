//
//  MBDialogGroupController.m
//  Core
//
//  Created by Frank van Eenbergen on 10/18/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDialogGroupController.h"
#import "MBMetadataService.h"
#import "MBActivityIndicator.h"
#import "MBDeviceType.h"

@implementation MBDialogGroupController

@synthesize name = _name;
@synthesize iconName = _iconName;
@synthesize title = _title;
@synthesize splitViewController = _splitViewController;
@synthesize keepLeftViewControllerVisibleInPortraitMode = _keepLeftViewControllerVisibleInPortraitMode;

- (void) dealloc
{
	[_name release];
	[_iconName release];
	[_title release];
	[_leftDialogController release];
	[_rightDialogController release];
	[_splitViewController release];
	[super dealloc];
}

-(id) initWithDefinition:(MBDialogGroupDefinition*)definition {
	if(self = [super init]) {
		_name = definition.name;
		_iconName = definition.icon;
		_title = definition.title;
		_activityIndicatorCount = 0;
		// TODO: Make the property leftViewControllerVisibleInPortraitMode variable (come from xml)
		_splitViewController = [[MBSplitViewController alloc] initWithLeftViewControllerVisibleInPortraitMode:YES];
	}
	return self;	
}
 
// Update the split view controller's view controllers array.
- (void) loadDialogs {
	
	UIViewController *leftViewController = _leftDialogController.rootController;
	UIViewController *rightViewController = _rightDialogController.rootController;
	
	// Use dummyViewControllers if the Dialog has no rootController, so the splitViewcontroller can still be created
	if (leftViewController==nil)  leftViewController  = [[[UIViewController alloc] init] autorelease];
	if (rightViewController==nil) rightViewController = [[[UIViewController alloc] init] autorelease];
	
	NSArray *viewControllers = [NSArray arrayWithObjects:leftViewController,rightViewController,nil];
	_splitViewController.viewControllers = viewControllers;
}

#pragma mark -
#pragma mark ActivityIndicator managment

- (void)showActivityIndicator {
	
	if(_activityIndicatorCount == 0) {
		CGRect bounds = [UIScreen mainScreen].applicationFrame;	
		
		// Somehow, the bounds of the applicationFrame on iPad, are not correct. 
		// The y starts at 20, while the frame for the application is 0. The code below corrects this.
		if ([MBDeviceType isPad]) {
			NSInteger correctiohHeight = bounds.origin.y;
			bounds.origin.y -= correctiohHeight;
			bounds.size.height+= correctiohHeight;
		}
		
		MBActivityIndicator *blocker = [[[MBActivityIndicator alloc] initWithFrame:bounds] autorelease];
		[_splitViewController.view addSubview:blocker];
	}
	_activityIndicatorCount ++;
}

- (void)hideActivityIndicator {
	if(_activityIndicatorCount > 0) {
		_activityIndicatorCount--;
		
		if(_activityIndicatorCount == 0) {
			UIView *top = [_splitViewController.view.subviews lastObject];
			if ([top isKindOfClass:[MBActivityIndicator class]])
				[top removeFromSuperview];
		}
	}
}

#pragma mark -
#pragma mark Setters
- (void) setLeftDialogController:(MBDialogController *) dialogController {
	if (_leftDialogController != dialogController) {
		[_leftDialogController release];
		_leftDialogController = dialogController;
		[_leftDialogController retain];
	}
}

- (void) setRightDialogController:(MBDialogController *) dialogController {
	if (_rightDialogController != dialogController) {
		[_rightDialogController release];
		_rightDialogController = dialogController;
		[_rightDialogController retain];
	}
}


#pragma mark -
#pragma mark Getters
- (MBDialogController *)leftDialogController {
	return _leftDialogController;
}

- (MBDialogController *)rightDialogController {
	return _rightDialogController;
}


@end
