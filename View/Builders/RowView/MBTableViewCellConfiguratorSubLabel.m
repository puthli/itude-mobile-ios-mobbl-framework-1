//
//  MBTableViewCellConfiguratorSubLabel 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTableViewCellConfiguratorSubLabel.h"


@implementation MBTableViewCellConfiguratorSubLabel

- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field
{
    if (field.path != nil) {
        cell.detailTextLabel.text = [field formattedValue];
    } else {
        cell.detailTextLabel.text = field.label;
    }
    cell.detailTextLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
    [self.styleHandler styleLabel:cell.detailTextLabel component:field];
}

@end