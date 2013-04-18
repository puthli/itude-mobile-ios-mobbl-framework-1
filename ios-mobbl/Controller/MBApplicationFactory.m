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
#import "MBAlert.h"
#import "MBPageDefinition.h"
#import "MBBasicViewController.h"
#import "MBTypes.h"
#import <objc/runtime.h>

@interface MBApplicationFactory () {
    MBTransitionStyleFactory *_transitionStyleFactory;
}
@end

@implementation MBApplicationFactory

@synthesize transitionStyleFactory = _transitionStyleFactory;
static MBApplicationFactory *_instance = nil;

- (void)dealloc
{
    [_transitionStyleFactory release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _transitionStyleFactory = [MBTransitionStyleFactory new];
    }
    return self;
}

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
            NSString *name = @"MBApplicationFactoryException";
            NSString *reason = [NSString stringWithFormat:@"The shared instance of the MBApplicationFactory is already set. It can't be overridden. The current instance is %@. Instance that you tried to set is %@. Hint: Try to set your own factory before the first call of sharedInstance on MBApplicationFactory. ",_instance, factory];
            @throw [NSException exceptionWithName:name reason:reason userInfo:nil];
            //[_instance release];
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

- (MBAlert *)createAlert:(MBAlertDefinition *)definition document:(MBDocument *)document rootPath:(NSString *)rootPath delegate:(id<UIAlertViewDelegate>)alertViewDelegate {
    return [[[MBAlert alloc] initWithDefinition:definition document:document rootPath:rootPath delegate:alertViewDelegate] autorelease];
}

-(id<MBAction>) createAction:(NSString *)actionClassName {
    id action = [[NSClassFromString(actionClassName) alloc] init];
    if ([action conformsToProtocol:@protocol(MBAction)]) {
        return [action autorelease];
    } else {
        [action release];
        [NSException raise:@"Invalid action class name" format:@"You have defined an action class named '%@' in your actions configuration but there is no objc class found with that name. Check the actions configuration or create a class named '%@' that follows the MBAction protocol.", actionClassName, actionClassName];
    }
    return nil;
}

-(id<MBResultListener>) createResultListener:(NSString *)listenerClassName {
    id listener = [[NSClassFromString(listenerClassName) alloc] init];
    if ([listener conformsToProtocol:@protocol(MBResultListener)]) {
        return [listener autorelease];
    } else {
        [listener release];
        [NSException raise:@"Invalid listener class name" format:@"Listener class name %@ is invalid", listenerClassName];
    }
	return nil;
}

- (NSString *)description
{
    const char* className = class_getName([self class]);
    return [NSString stringWithFormat:@"<%@: %p; className: %s>", [self class], self, className];
}

@end
