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
    
    [self configureView:cell.detailTextLabel forField:field];
    
}

@end