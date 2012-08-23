//
//  MBTableViewCellConfiguratorLabel 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBStyleHandler.h"
#import "MBTableViewCellConfiguratorLabel.h"
#import "MBLocalizationService.h"

@implementation MBTableViewCellConfiguratorLabel

- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field
{
    if (field.path != nil) {
        cell.textLabel.text = MBLocalizedString([field formattedValue]);
    } else {
        cell.textLabel.text = field.label;
    }
    cell.textLabel.frame = [self.styleHandler sizeForLabel:field withMaxBounds:CGRectZero];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}


@end