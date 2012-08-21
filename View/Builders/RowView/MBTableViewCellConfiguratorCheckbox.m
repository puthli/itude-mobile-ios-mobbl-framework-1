//
//  MBTableViewCellConfiguratorCheckbox 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import "MBTableViewCellConfiguratorCheckbox.h"


@implementation MBTableViewCellConfiguratorCheckbox

- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field
{
    UISwitch *switchView = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];

    // Always check the untranslated value
    if ([@"true" isEqualToString:[field untranslatedValue] ]) {
        switchView.on = YES;
    }
    if (!cell.textLabel.text){
        cell.textLabel.text = field.label;
    }
    [switchView addTarget:field action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];

    // reformat the frame
    NSInteger leftMargin = 10;
    CGRect frame = CGRectMake(
            cell.contentView.frame.size.width - switchView.frame.size.width - leftMargin,
            cell.contentView.frame.size.height / 2 - (switchView.frame.size.height / 2 + 1),
            switchView.frame.size.width, switchView.frame.size.height + 20);
    switchView.frame = frame;
    switchView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [cell.contentView addSubview:switchView];
    switchView.isAccessibilityElement = YES;
    switchView.accessibilityLabel = [NSString stringWithFormat:@"switch_%@", cell.textLabel.text];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}


@end