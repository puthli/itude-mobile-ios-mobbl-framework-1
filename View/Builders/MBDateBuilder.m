//
//  MBDateBuilder.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/6/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBDateBuilder.h"
#import "MBStyleHandler.h"

@implementation MBDateBuilder

-(UIView*)buildFieldView:(MBField*)field forTableCell:(UITableViewCell *)cell withMaxBounds:(CGRect) bounds {
    cell.textLabel.text = field.label;
    cell.detailTextLabel.text = [field formattedValue];
    cell.textLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.isAccessibilityElement = YES;
    cell.accessoryView.accessibilityLabel = @"DisclosureIndicator";

    
    [self.styleHandler styleLabel:cell.textLabel component:field];
    
    return cell.textLabel;

}

@end
