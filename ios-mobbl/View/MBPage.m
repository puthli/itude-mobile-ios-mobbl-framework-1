//
//  MBPage.m
//  Core
//
//  Created by Wido on 5/21/10.
//  Copyright 2010 Itude Mobile. All rights reserved.
//

#import "MBMacros.h"
#import "MBPage.h"
#import "MBOutcome.h"
#import "MBComponent.h"
#import "MBDefinition.h"
#import "MBForEachDefinition.h"
#import "MBForEach.h"
#import "MBOutcomeDefinition.h"
#import "MBMetadataService.h"
#import "MBViewBuilderFactory.h"
#import "MBPageViewBuilder.h"
#import "StringUtilities.h"
#import "MBViewControllerProtocol.h"
#import "MBComponentFactory.h"
#import "MBValueChangeListenerProtocol.h"
#import "MBSession.h"

@implementation MBPage

@synthesize pageName = _pageName;
@synthesize pageStackName = _pageStackName;
@synthesize document = _document;
@synthesize controller = _controller;
@synthesize childViewControllers = _childViewControllers;
@synthesize documentDiff = _documentDiff;
@synthesize pageType = _pageType;
@synthesize transitionStyle = _transitionStyle;

-(id) initWithDefinition:(MBPageDefinition*) definition 
      withViewController:(UIViewController<MBViewControllerProtocol>*) viewController 
                document:(MBDocument*) document 
                rootPath:(NSString*) rootPath 
			   viewState:(MBViewState) viewState {

	if(self = [super initWithDefinition:definition document: document parent: nil buildViewStructure: FALSE]) {
        self.definition = definition;
        self.rootPath = rootPath;
        self.pageName = definition.name;
		self.document = document;
		_valueChangedListeners = [NSMutableDictionary new];
		_outcomeListeners = [NSMutableArray new];
		_pageType = definition.pageType;
		_viewState = viewState;

		self.viewController = viewController;
		[self.viewController  setPage: self];
		
		// Ok; now we can build the children:
        for(MBDefinition *def in definition.children) {
			if([def isPreConditionValid:document currentPath:[self absoluteDataPath]]) [self addChild: [MBComponentFactory componentFromDefinition: def document: document parent: self]];
		}		
	}
	return self;
}

-(id) initWithDefinition:(MBPageDefinition*)definition 
				document:(MBDocument*) document 
				rootPath:(NSString*) rootPath
			   viewState:(MBViewState) viewState 
		   withMaxBounds:(CGRect) bounds {
	
    // Make sure that the Panel does not start building the view based on the children OF THIS PAGE because that is too early
    // The children need the additional information that is set after the constructor of super. So pass buildViewStructure: FALSE
    // and build the children ourselves here
	if(self = [super initWithDefinition:definition document: document parent: nil buildViewStructure: FALSE]) {
        self.rootPath = rootPath;
        self.document = document;
        self.pageName = definition.name;
		_maxBounds = bounds;
		_viewState = viewState;
		_valueChangedListeners = [NSMutableDictionary new];
		_outcomeListeners = [NSMutableArray new];
		_pageType = definition.pageType;

        // Ok; now we can build the children:
        for(MBDefinition *def in definition.children) {
			if([def isPreConditionValid:document currentPath:[[self parent] absoluteDataPath]]) [self addChild: [MBComponentFactory componentFromDefinition: def document: document parent: self]];
		}

        self.viewController = (UIViewController<MBViewControllerProtocol>*)[[MBApplicationFactory sharedInstance]createViewController:self];
        self.viewController.title = [self title];
        self.viewController.view = [self buildViewWithMaxBounds: bounds forParent: nil viewState: viewState];
        [self.viewController  setPage: self];
    }
	return self;
}

-(void) dealloc {
	[_document release];
	[_pageName release];
    [_pageStackName release];
	[_rootPath release];
    [_childViewControllers release];
	[_documentDiff release];
	[_valueChangedListeners release];
	[_outcomeListeners release];
    [_transitionStyle release];
	[super dealloc];
}

-(void) rebuild {
	[self.document clearAllCaches];
	[super rebuild];
}

-(void) rebuildView {
	// Make sure we clear the cache of all related documents:
	[self rebuild];
	CGRect bounds = [UIScreen mainScreen].applicationFrame;	
	self.viewController.view = [self buildViewWithMaxBounds: bounds forParent:nil viewState: _viewState];
}

// This is a method required by component so any component can find the page
-(MBPage*) page {
	return self;	
}

-(void) hideKeyboard: (id) msg {
	[self resignFirstResponder];
}

-(UIView*) buildViewWithMaxBounds:(CGRect) bounds forParent:(UIView*) parent  viewState:(MBViewState) viewState {
	return [[[MBViewBuilderFactory sharedInstance] pageViewBuilder] buildPageView: self withMaxBounds: bounds viewState: viewState];
}

-(void) handleException:(NSException *)exception {
	MBOutcome *outcome = [[MBOutcome alloc] initWithOutcomeName: self.pageName document:_document];
	[_controller handleException:exception outcome:outcome];
	[outcome release];	
}

-(void) handleOutcome:(NSString *)outcomeName {
	[self handleOutcome:outcomeName withPathArgument: nil];
}

-(void) handleOutcome:(NSString *)outcomeName withPathArgument:(NSString*) path {
	MBOutcome *outcome = [[MBOutcome alloc] init];
	outcome.originName = self.pageName;
	outcome.outcomeName = outcomeName;
	outcome.document = [self document];
	outcome.pageStackName = [self pageStackName];
	outcome.path = path;

	for(id<MBOutcomeListenerProtocol> lsnr in _outcomeListeners) {
		[lsnr outcomeProduced:outcome];	
	}
	
	[_controller handleOutcome:outcome];
	[outcome release];
}

-(NSString *) componentDataPath {
	return [self rootPath];
}

-(NSString *) description {
    return [NSString stringWithFormat:@"<%@: %p; pageID: %@>", [self class], self, _pageName];
}

-(void) setRootPath:(NSString *) path {

	BOOL ignorePath = FALSE;
	
	if(path == nil) path = @"";
    else if(![path hasSuffix:@"/"]) path = [NSString stringWithFormat:@"%@/", path];
	
	if([path length]>0) {
		MBPageDefinition* pd = (MBPageDefinition*) [self definition];
		NSString *stripped = [[path stripCharacters:@"[]0123456789"] normalizedPath];
		
		// If the last character is not a slash (/), add one.
		if (![stripped hasSuffix:@"/"]) {
			stripped = [NSString stringWithFormat:@"%@/", stripped]; 
		}
		
		
		
		NSString *mustBe = pd.rootPath;
		if(mustBe == nil || [mustBe isEqualToString:@""]) mustBe = @"/";
		 
		if(![stripped isEqualToString:mustBe]) {
			if([mustBe isEqualToString:@"/"]) {
				WLog(@"Ignoring path %@ because the document definition used root path %@", stripped, mustBe);
				ignorePath = TRUE;
			}
			else {
				NSString *msg = [NSString stringWithFormat:@"Invalid root path %@->%@; does not conform to defined document root path %@", path, stripped, mustBe];
				@throw [NSException exceptionWithName:@"InvalidPath" reason: msg userInfo:nil];
			}
		}
	}
	
    if(!ignorePath && _rootPath != path) {   
   	  [_rootPath release];
	  _rootPath = path;
	  [_rootPath retain];
    }
}

-(NSString*) rootPath {
	return _rootPath;
}

-(UIView*) view {
    return self.viewController.view;
}

-(void) setViewController:(UIViewController<MBViewControllerProtocol>*) viewController {
    [_viewController release];
    _viewController = viewController;
    [_viewController retain];
}

-(UIViewController<MBViewControllerProtocol>*) viewController {
    return _viewController;
}

- (void) unregisterAllViewControllers {
	self.childViewControllers = nil;	
}

- (void) registerViewController:(UIViewController*) controller {
    if(self.childViewControllers == nil) self.childViewControllers = [[NSMutableArray new] autorelease];
    if(![self.childViewControllers containsObject: controller]) [self.childViewControllers addObject:controller];
}

-(id) viewControllerOfType:(Class) clazz {
	if(self.childViewControllers != nil) {
		for (UIViewController *ctrl in self.childViewControllers) {
			if ([ctrl isKindOfClass: clazz]) return ctrl;
		}
	}
	return nil;
}
- (NSString *) asXmlWithLevel:(int)level {
	NSMutableString *result = [NSMutableString stringWithFormat: @"%*s<MBPage%@%@%@%@>\n", level, "",
							   [self attributeAsXml:@"pageName" withValue:_pageName],
							   [self attributeAsXml:@"rootPath" withValue:_rootPath],
							   [self attributeAsXml:@"pageStackName" withValue:_pageStackName],
							   [self attributeAsXml:@"document" withValue:_document.documentName]
							   ];

    [result appendString: [self childrenAsXmlWithLevel: level+2]];
	[result appendFormat:@"%*s</MBPage>\n", level, ""];
	
	return result;
}

-(MBDocumentDiff*) diffDocument:(MBDocument*) other {

	MBDocumentDiff *diff = [[MBDocumentDiff alloc]initWithDocumentA:self.document andDocumentB: other];
	self.documentDiff = diff;
	[diff release];
	
	return self.documentDiff;
}

-(NSMutableArray*) listenersForPath:(NSString*) path {
	if(![path hasPrefix:@"/"]) path = [NSString stringWithFormat:@"/%@", path];
	
	path = [path normalizedPath];
	NSMutableArray *lsnrList = [_valueChangedListeners valueForKey:path];
	if(lsnrList == nil) {
		lsnrList = [NSMutableArray array];
		[_valueChangedListeners setObject:lsnrList forKey:path];
	}
	return lsnrList;
}	

- (void) registerValueChangeListener:(id<MBValueChangeListenerProtocol>) listener forPath:(NSString*) path {
	// Check that the path is valid by reading the value:
	[[self document] valueForPath:path];
	
	NSMutableArray *lsnrList = [self listenersForPath: path];
	[lsnrList addObject:listener];
}

- (void) unregisterValueChangeListener:(id<MBValueChangeListenerProtocol>) listener forPath:(NSString*) path {
	// Check that the path is valid by reading the value:
	[[self document] valueForPath:path];
	
	NSMutableArray *lsnrList = [self listenersForPath: path];
	[lsnrList removeObject:listener];	
}

- (void) unregisterValueChangeListener:(id<MBValueChangeListenerProtocol>) listener {
	// Check that the path is valid by reading the value:
	
	for(NSMutableArray *list in [_valueChangedListeners allValues]) [list removeObject:listener];
}

- (BOOL) notifyValueWillChange:(NSString*) value originalValue:(NSString*) originalValue forPath:(NSString*) path {
	BOOL result = TRUE;
	NSMutableArray *lsnrList = [self listenersForPath: path];
	for(id lsnr in lsnrList) {
		if([lsnr respondsToSelector:@selector(valueWillChange:originalValue:forPath:)])
			result &= [lsnr valueWillChange:value originalValue:originalValue forPath:path];
	}
	return result;
}

- (void) notifyValueChanged:(NSString*) value originalValue:(NSString*) originalValue forPath:(NSString*) path {
	NSMutableArray *lsnrList = [self listenersForPath: path];
	for(id lsnr in lsnrList) {
		if([lsnr respondsToSelector:@selector(valueChanged:originalValue:forPath:)])
			[lsnr valueChanged:value originalValue:originalValue forPath:path];
	}
}

- (void) registerOutcomeListener:(id<MBOutcomeListenerProtocol>) listener {
	if(![_outcomeListeners containsObject:listener]) 	[_outcomeListeners addObject:listener];
}

- (void) unregisterOutcomeListener:(id<MBOutcomeListenerProtocol>) listener {
	[_outcomeListeners removeObject: listener];
}

- (MBViewState) currentViewState {
	return _viewState;	
}

@end
