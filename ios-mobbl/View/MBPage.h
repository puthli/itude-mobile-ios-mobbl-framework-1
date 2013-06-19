//
//  MBPage.h
//  Core
//
//  Created by Robin Puthli on 4/26/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//
//  Wraps a UIViewController

#import "MBApplicationFactory.h"
#import "MBComponent.h"
#import "MBPanel.h"
#import "MBViewControllerProtocol.h"
#import "MBDocumentDiff.h"
#import "MBPageDefinition.h"
#import "MBOutcomeListenerProtocol.h"
#import "MBTypes.h"

@class MBApplicationController;
@class MBApplicationFactory;

/** Main unit of navigation within the application. Associated with exactly one UIViewController subclass. You never need to subclass an MBPage */
@interface MBPage : MBPanel 

@property (nonatomic, retain) NSString *pageName;
@property (nonatomic, retain) NSString *rootPath;
@property (nonatomic, retain) NSString *dialogName;
@property (nonatomic, retain) MBDocument *document;
@property (nonatomic, assign) MBApplicationController *controller;
@property (nonatomic, retain) UIViewController <MBViewControllerProtocol>*viewController;
@property (nonatomic, retain) NSMutableArray *childViewControllers;
@property (nonatomic, retain) MBDocumentDiff *documentDiff;
@property (nonatomic, assign) MBPageType pageType;
@property (nonatomic, retain) NSString *transitionStyle;

// for loading interface builder files:
- (id) initWithDefinition:(MBPageDefinition*) definition 
	   withViewController:(UIViewController<MBViewControllerProtocol>*) viewController 
				 document:(MBDocument*) document 
				 rootPath:(NSString*) rootPath
				viewState:(MBViewState) viewState;

// for initialising a generic page:
- (id) initWithDefinition:(id)definition 
				 document:(MBDocument*) document 
				 rootPath:(NSString*) rootPath
				viewState:(MBViewState) viewState 
			withMaxBounds:(CGRect) bounds;

// Outcome handling
- (void) handleOutcome:(NSString *)outcomeName;
- (void) handleOutcome:(NSString *)outcomeName withPathArgument:(NSString*) path;
- (void) handleException:(NSException *)exception;
- (void) registerOutcomeListener:(id<MBOutcomeListenerProtocol>) listener;
- (void) unregisterOutcomeListener:(id<MBOutcomeListenerProtocol>) listener;

// View
- (UIView*) view;
- (void)rebuild;
- (void) rebuildView;
- (MBViewState) currentViewState;
- (void) unregisterAllViewControllers;
- (id) viewControllerOfType:(Class) clazz;

- (MBDocumentDiff*) diffDocument:(MBDocument*) other;

@end
