/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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
    if (self.viewControllers.count > 1) {
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
