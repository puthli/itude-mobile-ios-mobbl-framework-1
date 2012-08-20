//
//  MBApplication.h
//  Core
//
//  Created by Robin Puthli on 4/26/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBViewManager.h"
#import "MBApplicationController.h"
#import "MBPageDefinition.h"
#import "MBAction.h"
#import "MBResultListener.h"

@class MBApplicationController;
@class MBPage;
@class MBOutcome;
@class MBDocument;

/** Factory class for creating custom UIViewControllers, MBResultListeners and MBActions 
 * In short there are three steps to using custom code with MOBBL framework:

 1. Create Pages, Actions and ResultListeners in the application definition files  (config.xmlx and endpoints.xmlx).
 2. Create a subclass of the MBApplicationFactory which can create custom UIViewControllers, MBActions and MBResultListeners,
 3. set the sharedInstance to your MBApplicationFactory subclass:
 
     CustomApplicationFactory *applicationFactory = [[[CustomApplicationFactory alloc] init] autorelease];
     [MBApplicationFactory setSharedInstance:applicationFactory];

*/
@interface MBApplicationFactory :  NSObject {
}

/** the shared instance */
+(MBApplicationFactory *) sharedInstance;
+(void) setSharedInstance:(MBApplicationFactory *) factory;
/** override this class to create MBPages, UIViewControllers and bind the two together */
-(MBPage *) createPage:(MBPageDefinition *)definition 
			  document:(MBDocument*) document 
			  rootPath:(NSString*) rootPath 
			 viewState:(MBViewState) viewState 
		 withMaxBounds:(CGRect) bounds;
/** override to create MBAction conforming custom actions */
-(id<MBAction>) createAction:(NSString *)actionClassName;
/** override to create custom MBResultListeners */
-(id<MBResultListener>) createResultListener:(NSString *)listenerClassName;
-(UIViewController *) createViewController:(MBPage*) page;

@end
