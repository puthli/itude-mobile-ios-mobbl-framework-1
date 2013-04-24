//
//  MBConditionalPage.h
//  Core
//
//  Created by Wido on 5-7-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPage.h"

@interface MBConditionalPage : MBPage {
	MBPageDefinition *_definitionWhenFalse;
	MBPageDefinition *_definitionWhenTrue;
}

@property (nonatomic, retain)MBPageDefinition *definitionWhenFalse;
@property (nonatomic, retain)MBPageDefinition *definitionWhenTrue;

- (id) initWithDefinitionWhenTrue:(MBPageDefinition*) definitionWhenTrue 
		  WithDefinitionWhenFalse:(MBPageDefinition*) definitionWhenFalse 
			   withViewController:(UIViewController<MBViewControllerProtocol>*) viewController 
						 document:(MBDocument*) document 
						 rootPath:(NSString*) rootPath
						viewState:(MBViewState) viewState;
	
- (id) initWithDefinitionWhenTrue:(MBPageDefinition*) definitionWhenTrue 
		   WithDefinitionWhenFalse:(MBPageDefinition*) definitionWhenFalse 
						  document:(MBDocument*) document 
						  rootPath:(NSString*) rootPath
						 viewState:(MBViewState) viewState 
					 withMaxBounds:(CGRect) bounds;
	
@end
