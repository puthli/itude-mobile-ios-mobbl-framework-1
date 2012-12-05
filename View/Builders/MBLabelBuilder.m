//
//  MBLabelBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/27/11.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBLabelBuilder.h"
#import "MBField.h"
#import "MBStyleHandler.h"

@implementation MBLabelBuilder

-(UIView *)buildFieldView:(MBField *)field withMaxBounds:(CGRect)bounds {
 	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, [UIScreen mainScreen].applicationFrame.size.width, 25.0)];

    [self configureView:label forField:field];
	return [label autorelease];
}


-(void)configureView:(UIView *)view forField:(MBField *)field {
    UILabel *label = (UILabel*)view;
    if(field.path != nil) label.text = [field value];
	else label.text = field.label;
	label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask =   UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.styleHandler applyStyle:field forView: label viewState:0];
}

@end
