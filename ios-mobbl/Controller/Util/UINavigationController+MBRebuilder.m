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
        
        // Determine transitionStyle
        NSString *transitionStyle = [self currentTransitionStyle];
        
        // If we have a transitionStyle apply it
        if (transitionStyle.length > 0) {
            // First call. We need to pop the navigationBar so return YES.
            if ([self shouldPopNavigationItem]) {
                [self setShouldPopNavigationItem:FALSE];
                
                // Return YES to pop the navigationBar and the viewController in the second cycle
                return YES;
            }
            
            // Second Call. We don't want to pop the navigationItem again.
            else {
                
                // Set the boolean for the next call
                [self setShouldPopNavigationItem:TRUE];
                
                // Apply custom transition
                id<MBTransitionStyle> style = [[[MBApplicationFactory sharedInstance] transitionStyleFactory] transitionForStyle:transitionStyle];
                [style applyTransitionStyleToViewController:self forMovement:MBTransitionMovementPop];
                
                // This will pop the ViewController but not the navigationBar. It will also result in a second call of this delegate method
                [self popViewControllerAnimated:[style animated]];
                
                // Avoid a second pop
                return NO;
            }
        }
        
        // If we have no transitionStyle just allow the pop
        return YES;
    }

}


#pragma mark -
#pragma mark Helper methods

#define C_MBshouldPopNavigationItem_KEY @"MBshouldPopNavigationItem"

- (BOOL)shouldPopNavigationItem {
    NSMutableDictionary *dict = [[NSThread currentThread] threadDictionary];
    NSNumber *number = [dict objectForKey:C_MBshouldPopNavigationItem_KEY];
    return [number boolValue];
}

- (void) setShouldPopNavigationItem:(BOOL)pop {
    NSMutableDictionary *dict = [[NSThread currentThread] threadDictionary];
    [dict setObject:[NSNumber numberWithBool:pop] forKey:C_MBshouldPopNavigationItem_KEY];
}

- (NSString *)currentTransitionStyle {
    if ([[self topViewController] isKindOfClass:[MBBasicViewController class]]) {
        return [[(MBBasicViewController *) [self topViewController] page] transitionStyle];
    }
    return nil;
}

@end
