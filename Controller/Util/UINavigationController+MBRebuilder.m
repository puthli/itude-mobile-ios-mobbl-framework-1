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

#pragma mark -
#pragma mark UINavigationBarDelegate methods

-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    @synchronized(self) {
        
        // First call. We don't want to pop the navigationItem jet.
        if (![self shouldPopNavigationItem]) {

            // Set the boolean for the next call
            [self setShouldPopNavigationItem:TRUE];
            
            // TODO: Get the current transitionStyle
            // Apply custom transition
            NSString *transitionStyle = nil;//@"FADE";
            if ([[self topViewController] isKindOfClass:[MBBasicViewController class]]) {
                transitionStyle = [[(MBBasicViewController *) [self topViewController] page] transitionStyle];
            }
            
            id<MBTransitionStyle> style = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
            [style applyTransitionStyleToViewController:self];
            
            // This will pop the ViewController but not the navigationBar. It will also result in a second call of this delegate method
            [self popViewControllerAnimated:[style animated]];
            
            // Avoid a second pop
            return NO;
        }
        
        // Second Call. We need to pop the navigationBar so return YES.
        else { 
            [self setShouldPopNavigationItem:FALSE];
            
            // Return YES to pop the navigationBar and the viewController in the first cycle
            return YES;
        }
        
    }


}


#pragma mark -
#pragma mark Helper methods

#define C_MBshouldPopNavigationItem @"MBshouldPopNavigationItem"

- (BOOL)shouldPopNavigationItem {
    NSMutableDictionary *dict = [[NSThread currentThread] threadDictionary];
    NSNumber *number = [dict objectForKey:C_MBshouldPopNavigationItem];
    return [number boolValue];
}

- (void) setShouldPopNavigationItem:(BOOL)pop {
    NSMutableDictionary *dict = [[NSThread currentThread] threadDictionary];
    [dict setObject:[NSNumber numberWithBool:pop] forKey:C_MBshouldPopNavigationItem];
}

@end
