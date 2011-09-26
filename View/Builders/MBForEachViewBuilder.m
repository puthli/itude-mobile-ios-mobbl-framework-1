//
//  ForEachViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBForEachViewBuilder.h"
#import "MBForEach.h"
#import "MBStyleHandler.h"

@implementation MBForEachViewBuilder

-(UIView*) buildForEachView:(MBForEach*) forEach withMaxBounds:(CGRect) maxBounds viewState:(MBViewState) viewState {
	// One that we surely want to support here is the UITableView
	// For now do a simple implementation
	
	// Use a large canvas to begin with; and determine the actual size later
	// Using the default init constructor causes the nested children being unable to get focus for some reason
	
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 2000.0f, 2000.0f)] autorelease];  
	[forEach setupKeyboardHiding: view];
	
	CGRect boundsLeftOver = [self buildChildren: forEach.rows
										forView: view
							   horizontalLayout: FALSE
										 bounds: maxBounds
									  viewState: viewState];
	
	boundsLeftOver = [self buildChildren: forEach.children
								 forView: view
						horizontalLayout: FALSE
								  bounds: boundsLeftOver
							   viewState: viewState];
	
	[self adjustBoundsForView: view maxBounds: maxBounds boundsLeftOver: boundsLeftOver];
	[[self styleHandler] applyStyle:forEach forView:view viewState: viewState];

	return view;	
}

@end
