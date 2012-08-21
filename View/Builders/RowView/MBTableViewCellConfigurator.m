//
//  MBTableViewCellConfigurator 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <MBStyleHandler.h>
#import "MBTableViewCellConfigurator.h"


@implementation MBTableViewCellConfigurator

@synthesize styleHandler = _styleHandler;

- (void)addAccessoryDisclosureIndicatorToCell:(UITableViewCell *)cell
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.isAccessibilityElement = YES;
    cell.accessoryView.accessibilityLabel = @"DisclosureIndicator";
}

- (id)initWithStyleHandler:(MBStyleHandler *)styleHandler
{
    self = [super init];
    if (self) {
        _styleHandler = [styleHandler retain];
    }
    return self;
}

- (void)dealloc
{
    [_styleHandler release];
    [super dealloc];
}

- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field
{
    // Empty implementation, override in type-specific subclasses.
}


@end