//
//  MBConditionalPage.m
//  Core
//
//  Created by Wido on 5-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBConditionalPage.h"
#import "MBSession.h"

@implementation MBConditionalPage

@synthesize definitionWhenTrue = _definitionWhenTrue;
@synthesize definitionWhenFalse = _definitionWhenFalse;

- (id) initWithDefinitionWhenTrue:(MBPageDefinition*) definitionWhenTrue 
		  WithDefinitionWhenFalse:(MBPageDefinition*) definitionWhenFalse 
			   withViewController:(UIViewController<MBViewControllerProtocol>*) viewController 
						 document:(MBDocument*) document 
						 rootPath:(NSString*) rootPath
						viewState:(MBViewState) viewState {
	
	MBPageDefinition *def = ([[MBSession sharedInstance] loggedOn])?definitionWhenTrue:definitionWhenFalse;
	
	if(self = [super initWithDefinition:def 
				  withViewController:viewController 
							document:document
							rootPath:rootPath
							  viewState:viewState]) {
		self.definitionWhenTrue = definitionWhenTrue;
		self.definitionWhenFalse = definitionWhenFalse;
        self.pageName = definitionWhenTrue.name;
	}
	return self;
}

- (id) initWithDefinitionWhenTrue:(MBPageDefinition*) definitionWhenTrue 
		   WithDefinitionWhenFalse:(MBPageDefinition*) definitionWhenFalse 
				 document:(MBDocument*) document 
				 rootPath:(NSString*) rootPath
				viewState:(MBViewState) viewState 
			withMaxBounds:(CGRect) bounds {

	MBPageDefinition *def = ([[MBSession sharedInstance] loggedOn])?definitionWhenTrue:definitionWhenFalse;
	if(self = [super initWithDefinition:def
							document:document
							rootPath:rootPath
						   viewState:viewState
						  withMaxBounds:bounds])  {
		self.definitionWhenTrue = definitionWhenTrue;
		self.definitionWhenFalse = definitionWhenFalse;
        self.pageName = definitionWhenTrue.name;
	}
	return self;
}

- (void) dealloc
{
	[_definitionWhenTrue release];
	[_definitionWhenFalse release];
	[super dealloc];
}

-(void) rebuildView {
	self.definition = ([[MBSession sharedInstance] loggedOn])?self.definitionWhenTrue:self.definitionWhenFalse;
	[super rebuildView];
}

@end
