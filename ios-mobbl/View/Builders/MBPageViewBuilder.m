//
//  MBPageViewBuilder.m
//  Core
//
//  Created by Wido on 24-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBPageViewBuilder.h"
#import "MBPage.h"
#import "MBStyleHandler.h"
#import "MBViewManager.h"
#import "MBTypes.h"

@implementation MBPageViewBuilder

-(UIView*) buildPageView:(MBPage*) page withMaxBounds:(CGRect) maxBounds viewState:(MBViewState) viewState {
	UIView *view = [[[UIView alloc] initWithFrame: maxBounds] autorelease];  
	view.backgroundColor = [UIColor groupTableViewBackgroundColor];  
	
	[page setupKeyboardHiding: view];
	
	[self buildChildren: [page children]
				forView: view
	   horizontalLayout: FALSE
				 bounds: maxBounds
			  viewState: viewState];

	[[self styleHandler] applyStyle:page forView:view viewState: viewState];

	return view;	
}

@end
