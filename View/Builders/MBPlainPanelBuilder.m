//
//  MBPlainPanelBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBPlainPanelBuilder.h"
#import "MBViewBuilder+PanelHelper.h"

@implementation MBPlainPanelBuilder


-(UIView*)buildPanelView:(MBPanel *)panel withMaxBounds:(CGRect)bounds viewState:(MBViewState)viewState {
    UIView *view= [super buildPanelView:panel withMaxBounds:bounds viewState:viewState];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:bounds];
    scrollView.contentSize = view.frame.size;
    
    [scrollView addSubview:view];
    [scrollView autorelease];
    view = scrollView;
    
    //add accessibilityLabel for ui automation
    view.accessibilityLabel = [self getAccessibilityLabelForPanel:panel];
	
    return view;
}



@end
