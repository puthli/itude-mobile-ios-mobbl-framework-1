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

    [self configureLabel:label forField:field];
	return [label autorelease];
}

-(UIView*)buildFieldView:(MBField*)field forTableCell:(UITableViewCell *)cell withMaxBounds:(CGRect) bounds {
    UILabel *label = cell.textLabel;
    [self configureLabel:label forField: field];
    return label;
}

-(void)configureLabel:(UILabel *)label forField:(MBField *)field {
    label.text = [field formattedValue];
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping; //UILineBreakModeWordWrap;
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;

    label.autoresizingMask =   UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.styleHandler applyStyle:field forView: label viewState:0];
}

@end
