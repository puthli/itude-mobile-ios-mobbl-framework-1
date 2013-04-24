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
@interface MBPage : MBPanel {
	NSString *_pageName;
	NSString *_rootPath;
	NSString *_dialogName;
    MBDocument *_document;
	MBApplicationController *_controller;
    UIViewController<MBViewControllerProtocol> *_viewController;
    NSMutableArray *_childViewControllers;
	MBDocumentDiff *_documentDiff;
	NSMutableDictionary *_valueChangedListeners;
	NSMutableArray *_outcomeListeners;
	MBPageType _pageType;
	CGRect _maxBounds;
	MBViewState _viewState;
    NSString *_transitionStyle;
}

@property (nonatomic, retain) NSString *pageName;
@property (nonatomic, retain) NSString *dialogName;
@property (nonatomic, assign) MBApplicationController *controller;
@property (nonatomic, retain) MBDocument *document;
@property (nonatomic, retain) MBDocumentDiff *documentDiff;
@property (nonatomic, retain) NSMutableArray *childViewControllers;
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

- (void) handleOutcome:(NSString *)outcomeName;
- (void) handleOutcome:(NSString *)outcomeName withPathArgument:(NSString*) path;
- (void) handleException:(NSException *)exception;
- (NSString*) rootPath;
- (void) setRootPath:(NSString*) path;
- (UIView*) view;
- (void) setViewController:(UIViewController<MBViewControllerProtocol>*) viewController;
- (UIViewController<MBViewControllerProtocol>*) viewController;
- (MBDocumentDiff*) diffDocument:(MBDocument*) other;
- (void) registerOutcomeListener:(id<MBOutcomeListenerProtocol>) listener;
- (void) unregisterOutcomeListener:(id<MBOutcomeListenerProtocol>) listener;

- (void)rebuild;
- (void) rebuildView;

- (MBViewState) currentViewState;
- (void) unregisterAllViewControllers;
- (id) viewControllerOfType:(Class) clazz;

@end
