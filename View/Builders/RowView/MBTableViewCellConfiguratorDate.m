//
//  MBTableViewCellConfiguratorDate 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTableViewCellConfiguratorDate.h"

@implementation MBTableViewCellConfiguratorDate

- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field
{
    cell.textLabel.text = field.label;
    cell.detailTextLabel.text = [field formattedValue];
    cell.textLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
    [self addAccessoryDisclosureIndicatorToCell:cell];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}

@end