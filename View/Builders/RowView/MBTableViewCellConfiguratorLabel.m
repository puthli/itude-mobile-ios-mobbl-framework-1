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
    [self configureView:cell.textLabel forField:field];
}


@end