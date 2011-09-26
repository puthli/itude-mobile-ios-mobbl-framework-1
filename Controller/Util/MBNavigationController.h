//
//  MBNavigationController.h
//  Core
//
//  Created by Wido on 4-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//



@interface MBNavigationController : UINavigationController {
	UIViewController *fakeRootViewController;
	BOOL _viewWillAppearFirstCall;
	BOOL _viewDidAppearFirstCall;
}

@property(nonatomic, retain) UIViewController *fakeRootViewController;
@property(nonatomic, assign) BOOL viewWillAppearFirstCall;
@property(nonatomic, assign) BOOL viewDidAppearFirstCall;

-(void)setRootViewController:(UIViewController *)rootViewController;
-(void) rebuild;

@end

