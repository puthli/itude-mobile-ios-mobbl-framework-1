//
//  UINavigationController+MBRebuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/12/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "UINavigationController+MBRebuilder.h"
#import "MBBasicViewController.h"


@implementation UINavigationController (MBRebuilder)

-(void) popStack {
//	[self popToViewController:self.fakeRootViewController animated:NO];
}

-(void)rebuild {
    NSArray *controllers = [NSArray arrayWithArray:[self viewControllers]];
    
    [self popStack];
	for(MBBasicViewController *ctrl in controllers) {
		if([ctrl respondsToSelector:@selector(rebuildView)]) [ctrl rebuildView];
        
		// To avoid superfluious apper/disappear call the super; not self:
		[self pushViewController:ctrl animated:NO];
	}

}

-(void)setRootViewController:(UIViewController *)rootViewController {
    rootViewController.navigationItem.hidesBackButton = YES;
    [self popStack];
    [self pushViewController:rootViewController animated:NO];
}

@end
