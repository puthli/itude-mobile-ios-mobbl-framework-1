//
//  MBSplitViewController.h
//  Core
//
//  Created by Frank van Eenbergen on 10/20/10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//


#import "MGSplitViewController.h"


@interface MBSplitViewController : MGSplitViewController <MGSplitViewControllerDelegate> {
	BOOL _keepLeftViewControllerVisibleInPortraitMode;
}

@property (nonatomic, assign) BOOL keepLeftViewControllerVisibleInPortraitMode;

// It is possible to keep the Master View in portrait mode. Just pass YES to this method to enable this mode.
- (id) initWithLeftViewControllerVisibleInPortraitMode:(BOOL) visible;
- (void) reloadViewControllers;
- (void) reloadViewControllers:(UIInterfaceOrientation) interfaceOrientation;

@end
