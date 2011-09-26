//
//  MBViewBuilder.m
//  Core
//
//  Created by Wido on 25-5-10.
//  Copyright 2010 Itude Mobile BV. All rights reserved.
//

#import "MBViewBuilder.h"
#import "MBViewBuilderFactory.h"
#import "MBComponent.h"
#import "MBStyleHandler.h"

@implementation MBViewBuilder

-(MBStyleHandler*) styleHandler {
	return [[MBViewBuilderFactory sharedInstance] styleHandler];	
}

-(CGRect) buildChildren:(NSArray*) children 
				forView:(UIView*) view 
	   horizontalLayout:(BOOL) horizontalLayout
				 bounds:(CGRect) maxBounds 
			  viewState:(MBViewState) viewState {

	if([children count] == 0) return maxBounds;
	
	CGFloat xOffset = 0;
	CGFloat yOffset = 0;
	CGFloat width = maxBounds.size.width / [children count];

	for(MBComponent *child in children) {
		
		[[self styleHandler] applyInsetsForComponent:child];
		int insetLeft = child.leftInset;
		int insetTop = child.topInset;
		int insetRight = child.rightInset;
		int insetBottom = child.bottomInset;
		
		CGRect maxChildBounds = maxBounds;
		maxChildBounds.size.width -= insetLeft + insetRight;
		maxChildBounds.size.height -= insetTop + insetBottom;
		UIView *childView = [child buildViewWithMaxBounds:maxChildBounds viewState: viewState];
		
		if(childView)
		{
			xOffset += insetLeft;
			yOffset += insetTop;
			CGRect frame = childView.frame;
			frame.origin.x = xOffset;
			frame.origin.y = yOffset; 
			
			if(horizontalLayout) frame.size.width = width;
			
			frame.size.width -= insetLeft + insetRight;
			frame.size.height -= insetTop + insetBottom;
			
			childView.frame = frame;
			[view addSubview:childView];
			
			if(horizontalLayout) {
				xOffset += childView.frame.size.width;
				maxBounds.size.width = MAX(maxBounds.size.width - frame.size.width, 0);
			}
			else {
				yOffset += childView.frame.size.height;
				maxBounds.size.height = MAX(maxBounds.size.height - frame.size.height, 0);
			}
		}
	}
	
	// return the height that is left over in maxbounds
	return maxBounds;
}

-(void) adjustBoundsForView:(UIView*) view maxBounds:(CGRect) maxBounds boundsLeftOver:(CGRect) boundsLeftOver {
	view.bounds = CGRectMake(0, 0, boundsLeftOver.size.width, maxBounds.size.height - boundsLeftOver.size.height);
}

@end
