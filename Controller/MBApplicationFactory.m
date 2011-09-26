//
//  MBApplication.m
//  Core
//
//  Created by Robin, Wido on 5/26/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBApplicationFactory.h"
#import "MBAction.h"
#import "MBMetadataService.h"
#import "MBOutcome.h"
#import "MBPage.h"
#import "MBPageDefinition.h"
#import "MBBasicViewController.h"
#import "MBTypes.h"

@implementation MBApplicationFactory

static MBApplicationFactory *_instance = nil;

+(MBApplicationFactory *) sharedInstance {
	@synchronized(self) {
		if(_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
	return _instance;
}

+(void) setSharedInstance:(MBApplicationFactory *) factory {
	@synchronized(self) {
		if(_instance != nil && _instance != factory) {
			[_instance release];
		}
		_instance = factory;
		[_instance retain];
	}
}

-(MBPage *) createPage:(MBPageDefinition *)definition 
			  document:(MBDocument*) document 
			  rootPath:(NSString*) rootPath 
			 viewState:(MBViewState) viewState 
		 withMaxBounds:(CGRect) bounds {
	return [[[MBPage alloc] initWithDefinition: definition document: document rootPath:(NSString*) rootPath viewState: viewState withMaxBounds: bounds] autorelease];
}

-(UIViewController<MBViewControllerProtocol> *) createViewController:(MBPage*) page {
    return [[[MBBasicViewController alloc] init] autorelease];
}

-(id<MBAction>) createAction:(NSString *)actionClassName {
	// Override in the	applicationFactory specific for the app; return the app specific actions
	return nil;
}

-(id<MBResultListener>) createResultListener:(NSString *)listenerClassName {
	// Override in the	applicationFactory specific for the app; return the app specific actions
	return nil;
}

@end
