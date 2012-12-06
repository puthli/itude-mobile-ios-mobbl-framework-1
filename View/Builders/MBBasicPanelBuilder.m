//
//  MBBasicPanelBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBBasicPanelBuilder.h"
#import "MBPanel.h"

@implementation MBBasicPanelBuilder


-(UIView*)buildPanelView:(MBPanel *)panel  forParent:(UIView*) parent  withMaxBounds:(CGRect)bounds viewState:(MBViewState)viewState {
    
    // Use a large canvas to begin with; and determine the actual size later
	// Using the default init constructor causes the nested children being unable to get focus for some reason
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2000.0f, 2000.0f)] autorelease];
	
	CGRect boundsLeftOver = [self buildChildren: [panel children]
										forView: view
							   horizontalLayout: FALSE
										 bounds: bounds
									  viewState: viewState];
	
	[self adjustBoundsForView: view maxBounds: bounds boundsLeftOver: boundsLeftOver];
    
    [parent addSubview:view];
    
    return view;

}
@end
