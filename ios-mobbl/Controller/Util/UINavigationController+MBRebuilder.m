//
//  UINavigationController+MBRebuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/12/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "UINavigationController+MBRebuilder.h"
#import "MBBasicViewController.h"

#import "MBApplicationFactory.h"
#import "MBTransitionStyle.h"
#import "MBPage.h"

@implementation UINavigationController (MBRebuilder) 


-(void)rebuild {
    NSArray *controllers = [NSArray arrayWithArray:[self viewControllers]];
	for(MBBasicViewController *ctrl in controllers) {
		if([ctrl respondsToSelector:@selector(rebuildView)]) [ctrl rebuildView];
        
		// To avoid superfluious apper/disappear call the super; not self:
		[self pushViewController:ctrl animated:NO];
	}

}

-(void)setRootViewController:(UIViewController *)rootViewController {
    
    if (self.viewControllers.count == 0) {
        rootViewController.navigationItem.hidesBackButton = YES;
        [self pushViewController:rootViewController animated:NO];
    }
    else {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
        [viewControllers removeObjectAtIndex:0];
        [viewControllers insertObject:rootViewController atIndex:0];
        [self setViewControllers:viewControllers];
    }

}

-(void)replaceLastViewController:(UIViewController *)viewController {
    if (self.viewControllers.count > 0) {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
        [viewControllers removeLastObject];
        [viewControllers addObject:viewController];
        [self setViewControllers:viewControllers animated:NO];
    }
    else {
        [self setRootViewController:viewController];
    }
}

@end
