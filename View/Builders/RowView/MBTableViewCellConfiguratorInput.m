//
//  MBTableViewCellConfiguratorInput 
//
//  Created by Pieter Kuijpers on 20-08-12.
//  Copyright (c) 2012 Itude Mobile. All rights reserved.
//

#import <MBViewBuilderFactory.h>
#import "MBTableViewCellConfiguratorInput.h"
#import "MBFieldViewBuilderFactory.h"


@implementation MBTableViewCellConfiguratorInput

- (void)configureCell:(UITableViewCell *)cell withField:(MBField *)field
{
// store field for retrieval in didSelectRowAtIndexPath
    UIView *inputFieldView = [[[MBViewBuilderFactory sharedInstance] fieldViewBuilderFactory]  buildFieldView:field withMaxBounds:CGRectZero];
    field.responder = inputFieldView;

    if (!cell.textLabel.text){
        cell.textLabel.text = field.label;
    }

    // reformat the frame
    CGRect frame = CGRectMake(0,
                              cell.contentView.frame.size.height / 2 - inputFieldView.frame.size.height / 2 + 2,
                              inputFieldView.frame.size.width, inputFieldView.frame.size.height);
    inputFieldView.frame = frame;
    [cell.contentView addSubview:inputFieldView];

    // modified for KIF Testing
    // inputFieldView is the super view of the real UITextField that we should use in KIF method call +
    // (id)stepToEnterText:(NSString *)text intoViewWithAccessibilityLabel:(NSString *)label;
    // therefore we should explicitly make the real UITextField accessible and give it a special label to
    // be identified in KIF
    UITextField *textField = [inputFieldView.subviews objectAtIndex:0];
    textField.isAccessibilityElement = YES;
    textField.accessibilityLabel = [NSString stringWithFormat:@"input_%@", cell.textLabel.text];

    [self.styleHandler styleTextfield:inputFieldView component:field];
    [self.styleHandler styleLabel:cell.textLabel component:field];
}


@end