//
//  MBDefaultRowViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBDefaultRowViewBuilder.h"
#import "MBRow.h"
#import "MBComponent.h"
#import "MBStyleHandler.h"

@implementation MBDefaultRowViewBuilder


-(UIView*) buildRowView:(MBRow*) row withMaxBounds:(CGRect) maxBounds viewState:(MBViewState) viewState {
	
	// Use a large canvas to begin with; and determine the actual size later
	// Using the default init constructor causes the nested children being unable to get focus for some reason
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2000.0f, 2000.0f)] autorelease];  
	view.backgroundColor = [UIColor lightGrayColor];  
	
	CGRect boundsLeftOver = [self buildChildren: row.children
										forView: view
							   horizontalLayout: FALSE
										 bounds: maxBounds
									  viewState: viewState];
	
	[self adjustBoundsForView: view maxBounds: maxBounds boundsLeftOver: boundsLeftOver];
	[[self styleHandler] applyStyle:row forView:view viewState: viewState];

	return view;	
}

@end
