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

@interface MBApplicationFactory :  NSObject {
}

+(MBApplicationFactory *) sharedInstance;
+(void) setSharedInstance:(MBApplicationFactory *) factory;

-(UIViewController *) createViewController:(MBPage*) page;
-(MBPage *) createPage:(MBPageDefinition *)definition 
			  document:(MBDocument*) document 
			  rootPath:(NSString*) rootPath 
			 viewState:(MBViewState) viewState 
		 withMaxBounds:(CGRect) bounds;
-(id<MBAction>) createAction:(NSString *)actionClassName;
-(id<MBResultListener>) createResultListener:(NSString *)listenerClassName;

@end
