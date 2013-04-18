//
//  MBViewBuilder.h
//  Core
//
//  Created by Wido on 25-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBTypes.h"

@class MBStyleHandler;

@interface MBViewBuilder : NSObject {

}

-(CGRect) buildChildren:(NSArray*) children 
				forView:(UIView*) view 
	   horizontalLayout:(BOOL) horizontalLayout
				 bounds:(CGRect) maxBounds 
			  viewState:(MBViewState) viewState;

-(void) adjustBoundsForView:(UIView*) view 
				  maxBounds:(CGRect) maxBounds 
			 boundsLeftOver:(CGRect) boundsLeftOver;

-(MBStyleHandler*) styleHandler;

@end
