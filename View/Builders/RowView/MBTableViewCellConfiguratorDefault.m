//
//  MBTableViewCellConfiguratorDefault.m
//  itude-mobile-ios-app
//
//  Created by Pjotter Tommassen on 2012/5/12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTableViewCellConfiguratorDefault.h"
#import "MBViewBuilderFactory.h"

@implementation MBTableViewCellConfiguratorDefault



-(void)configureCell:(UITableViewCell *)cell withField:(MBField *)field {
    UIView *child  =
    [[[MBViewBuilderFactory sharedInstance] fieldViewBuilderFactory] buildFieldView:field withMaxBounds:cell.frame];
    
    CGFloat width = child.frame.size.width;
    
    for (UIView *subview in cell.contentView.subviews) {
        CGRect frame = subview.frame;
        frame.origin.x -= width;
        subview.frame = frame;
    }
    
    CGFloat right = cell.bounds.size.width;
    CGRect frame = child.frame;
    frame.origin.x= right - width;
    frame.origin.y = (cell.frame.size.height - frame.size.height) / 2;
    child.frame = frame;
    child.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [cell.contentView addSubview:child];
}
@end
